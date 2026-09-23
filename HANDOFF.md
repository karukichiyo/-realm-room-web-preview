# Preview16 · 房间三面网格 PNG 导出

2026-09-23，接续 preview15。当前源码仍为 `work/realm-room-preview10-20260922/godot`。

修复非正方形房间导出网格左侧或右侧被裁切：原实现把后墙交点固定在 1024 正方形中央，未补偿宽、深不对称的投影范围。现在采用 RoomView 的 TILE_X/TILE_Y/Z_PIXELS 投影常量，以三面网格完整包围范围计算画布与原点，四周约 32px 透明留白，线宽不会越界。

正常房间保持统一每格像素密度；PNG 宽高随房间宽、深、墙高自动变化。极大导入房间等比缩小以保持最长边不超过 4096px，不改变透视。整数和小数尺寸均绘制到最终边界。继续输出透明 PNG，查看器的黑色背景不属于图片。

下载文件名改用 Godot 支持的数字格式，例如 realm-room-grid-8x18x6.png，修复原来的字面 %g。

只修改 asset_editor.gd，新增 test_grid_export.gd，并更新旧投影测试对固定 1024×1024 的过时断言。实际打补丁 PCK 验证七种长宽高，包括长房、宽房、最小/最大常规尺寸和小数尺寸；检查每个可见角点、四周留白、PNG 编解码、文件名和当前房间尺寸传入导出器。另回归原家具投影/环境测试。

构建入口 `work/build_grid_release.py`，保留 preview15 全部补丁及原网站素材。实际发布散列见 release.json，线上下载验证见 verification/live-release.json。网页发布目标保持原 GitHub Pages。原 Windows preview15 便携包没有自动升级，需替换 PCK 才能包含此次修复。
