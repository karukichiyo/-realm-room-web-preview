#!/usr/bin/env python3
"""Patch selected GDScript bytecode files into a Godot PCK v3 archive."""

import hashlib
import struct
import sys
from pathlib import Path


source_pck, output_pck, replacements_dir, *replacement_paths = map(Path, sys.argv[1:])
raw = source_pck.read_bytes()
file_base = struct.unpack_from("<Q", raw, 24)[0]
directory_offset = struct.unpack_from("<Q", raw, 32)[0]
cursor = directory_offset
file_count = struct.unpack_from("<I", raw, cursor)[0]
cursor += 4
entries = []
for _ in range(file_count):
    path_len = struct.unpack_from("<I", raw, cursor)[0]
    cursor += 4
    path = raw[cursor:cursor + path_len].rstrip(b"\0").decode()
    cursor += path_len
    offset, size = struct.unpack_from("<QQ", raw, cursor)
    cursor += 16
    checksum = raw[cursor:cursor + 16]
    cursor += 16
    flags = struct.unpack_from("<I", raw, cursor)[0]
    cursor += 4
    entries.append((path, offset, size, checksum, flags))

replacements = {str(path): (replacements_dir / path.name).read_bytes() for path in replacement_paths}
with output_pck.open("wb") as output:
    output.write(raw[:file_base])
    rebuilt = []
    for path, offset, size, checksum, flags in entries:
        output.write(b"\0" * ((-output.tell()) % 16))
        data = replacements.get(path, raw[file_base + offset:file_base + offset + size])
        rebuilt.append((path, output.tell() - file_base, len(data), hashlib.md5(data).digest(), flags))
        output.write(data)
    known = {entry[0] for entry in entries}
    for path in sorted(set(replacements) - known):
        output.write(b"\0" * ((-output.tell()) % 16))
        data = replacements[path]
        rebuilt.append((path, output.tell() - file_base, len(data), hashlib.md5(data).digest(), 0))
        output.write(data)
    output.write(b"\0" * ((-output.tell()) % 16))
    new_directory_offset = output.tell()
    output.write(struct.pack("<I", len(rebuilt)))
    for path, offset, size, checksum, flags in rebuilt:
        encoded = path.encode() + b"\0"
        encoded += b"\0" * ((-len(encoded)) % 4)
        output.write(struct.pack("<I", len(encoded)))
        output.write(encoded)
        output.write(struct.pack("<QQ", offset, size))
        output.write(checksum)
        output.write(struct.pack("<I", flags))
    output.seek(32)
    output.write(struct.pack("<Q", new_directory_offset))
