import { App, Widget, Utils } from 'resource:///com/github/Aylur/ags/app.js';

// 壁紙ディレクトリとグローバル変数
let wallpaperDir: string = `${Utils.HOME}/Pictures/Wallpapers`;
let currentWallpaper: string = '';
let imageWidgets: { widget: any; path: string }[] = [];

// メインウィンドウ
const WallpaperSelector = () => Widget.Window({
    name: 'wallpaper-selector',
    title: '壁紙選択',
    class_name: 'wallpaper-selector',
    layer: 'overlay',
    anchor: ['top', 'bottom', 'left', 'right'],
    exclusivity: 'exclusive',
    keymode: 'on-demand',
    setup: self => {
        self.keybind('Escape', () => {
            App.quit();
        });
    },
    child: Widget.Box({
        class_name: 'main-container',
        orientation: 'vertical',
        children: [
            // ヘッダー
            Widget.Box({
                class_name: 'header',
                orientation: 'horizontal',
                children: [
                    Widget.Label({
                        label: '壁紙選択',
                        class_name: 'title',
                        hpack: 'start',
                    }),
                    Widget.Box({
                        hpack: 'end',
                        children: [
                            Widget.Button({
                                label: 'ディレクトリ選択',
                                class_name: 'dir-button',
                                on_clicked: () => selectDirectory(),
                            }),
                            Widget.Button({
                                label: '×',
                                class_name: 'close-button',
                                on_clicked: () => App.quit(),
                            }),
                        ],
                    }),
                ],
            }),

            // スクロール可能な画像グリッド
            Widget.Scrollable({
                class_name: 'image-container',
                hscroll: 'never',
                vscroll: 'automatic',
                child: Widget.Box({
                    class_name: 'image-grid',
                    orientation: 'vertical',
                    setup: self => {
                        loadWallpapers(self);
                    },
                }),
            }),

            // 下部ボタン
            Widget.Box({
                class_name: 'footer',
                orientation: 'horizontal',
                children: [
                    Widget.Label({
                        label: '',
                        class_name: 'current-info',
                        hpack: 'start',
                        setup: self => {
                            self.hook(App, () => {
                                if (currentWallpaper) {
                                    self.label = `選択中: ${GLib.path_get_basename(currentWallpaper)}`;
                                }
                            });
                        },
                    }),
                    Widget.Box({
                        hpack: 'end',
                        children: [
                            Widget.Button({
                                label: 'キャンセル',
                                class_name: 'cancel-button',
                                on_clicked: () => App.quit(),
                            }),
                            Widget.Button({
                                label: '適用',
                                class_name: 'apply-button',
                                on_clicked: () => applyWallpaper(),
                            }),
                        ],
                    }),
                ],
            }),
        ],
    }),
});

// 壁紙ディレクトリから画像を読み込み
function loadWallpapers(container) {
    // 既存の子要素をクリア
    container.children = [];
    imageWidgets = [];

    // Utils.execを使ってファイル一覧を取得
    let wallpapers = [];
    try {
        const lsResult = Utils.exec(`find "${wallpaperDir}" -type f \\( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \\) 2>/dev/null | sort`);
        if (lsResult.trim()) {
            wallpapers = lsResult.trim().split('\n');
        }
    } catch (e) {
        print(`Error reading directory: ${e.message}`);
        container.children = [Widget.Label({
            label: `ディレクトリが見つかりません: ${wallpaperDir}`,
            class_name: 'error-message',
        })];
        return;
    }

    if (wallpapers.length === 0) {
        container.children = [Widget.Label({
            label: 'このディレクトリには画像ファイルがありません',
            class_name: 'error-message',
        })];
        return;
    }

    // 画像を3列のグリッドで表示
    let currentRow = null;
    wallpapers.forEach((wallpaper, index) => {
        if (index % 3 === 0) {
            currentRow = Widget.Box({
                class_name: 'image-row',
                orientation: 'horizontal',
                homogeneous: true,
            });
            container.children = [...container.children, currentRow];
        }

        const fileName = wallpaper.split('/').pop();
        const imageWidget = Widget.Button({
            class_name: 'image-button',
            on_clicked: () => selectWallpaper(wallpaper),
            child: Widget.Box({
                class_name: 'image-box',
                orientation: 'vertical',
                children: [
                    Widget.Box({
                        class_name: 'image-wrapper',
                        css: `
                            background-image: url('file://${wallpaper}');
                            background-size: cover;
                            background-position: center;
                            min-height: 120px;
                            min-width: 180px;
                        `,
                    }),
                    Widget.Label({
                        label: fileName,
                        class_name: 'image-name',
                        truncate: true,
                        max_width_chars: 20,
                    }),
                ],
            }),
        });

        imageWidgets.push({ widget: imageWidget, path: wallpaper });
        currentRow.children = [...currentRow.children, imageWidget];
    });
}

// 壁紙を選択
function selectWallpaper(wallpaperPath) {
    currentWallpaper = wallpaperPath;
    
    // 一時的に壁紙をプレビュー適用
    Utils.exec(`bash -c 'pkill hyprpaper 2>/dev/null || true'`);
    Utils.exec(`bash -c 'echo "preload = ${wallpaperPath}" > ~/.config/hypr/hyprpaper.conf'`);
    Utils.exec(`bash -c 'echo "wallpaper = , ${wallpaperPath}" >> ~/.config/hypr/hyprpaper.conf'`);
    Utils.exec(`bash -c 'echo "splash = false" >> ~/.config/hypr/hyprpaper.conf'`);
    Utils.exec(`bash -c 'echo "ipc = on" >> ~/.config/hypr/hyprpaper.conf'`);
    Utils.exec('hyprpaper &');

    // 選択状態の視覚的フィードバック
    imageWidgets.forEach(item => {
        if (item.path === wallpaperPath) {
            item.widget.class_name = 'image-button selected';
        } else {
            item.widget.class_name = 'image-button';
        }
    });
}

// ディレクトリ選択
function selectDirectory() {
    const cmd = `zenity --file-selection --directory --title="壁紙ディレクトリを選択してください" --filename="${wallpaperDir}/"`;
    
    Utils.execAsync(['bash', '-c', cmd])
        .then(output => {
            const newDir = output.trim();
            if (newDir && newDir !== wallpaperDir) {
                wallpaperDir = newDir;
                // 画像グリッドを再読み込み
                const container = App.getWindow('wallpaper-selector').child.children[1].child;
                loadWallpapers(container);
            }
        })
        .catch((err: any) => {
            print(`Directory selection cancelled or failed: ${err}`);
        });
}

// 壁紙を適用
function applyWallpaper() {
    if (!currentWallpaper) {
        print('No wallpaper selected');
        return;
    }

    const applyCmd = `change-wallpaper --apply "${currentWallpaper}"`;
    
    Utils.execAsync(['bash', '-c', applyCmd])
        .then(() => {
            print(`Wallpaper applied: ${currentWallpaper}`);
            App.quit();
        })
        .catch((err: any) => {
            print(`Failed to apply wallpaper: ${err}`);
        });
}

// CSSスタイル
const css = `
.main-container {
    background-color: rgba(0, 0, 0, 0.9);
    border-radius: 10px;
    margin: 20px;
    padding: 20px;
}

.header {
    padding: 10px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    margin-bottom: 20px;
}

.title {
    font-size: 18px;
    font-weight: bold;
    color: white;
}

.dir-button, .close-button, .cancel-button, .apply-button {
    padding: 8px 16px;
    margin-left: 10px;
    border-radius: 5px;
    border: none;
    font-weight: bold;
}

.dir-button {
    background-color: rgba(100, 149, 237, 0.8);
    color: white;
}

.close-button, .cancel-button {
    background-color: rgba(220, 53, 69, 0.8);
    color: white;
}

.apply-button {
    background-color: rgba(40, 167, 69, 0.8);
    color: white;
}

.image-container {
    min-height: 400px;
    max-height: 500px;
}

.image-row {
    margin-bottom: 15px;
}

.image-button {
    margin: 5px;
    border-radius: 8px;
    border: 2px solid transparent;
    background-color: rgba(255, 255, 255, 0.1);
    padding: 10px;
}

.image-button:hover {
    border-color: rgba(100, 149, 237, 0.8);
}

.image-button.selected {
    border-color: rgba(40, 167, 69, 0.9);
    background-color: rgba(40, 167, 69, 0.2);
}

.image-wrapper {
    border-radius: 5px;
    overflow: hidden;
}

.image-name {
    color: white;
    font-size: 12px;
    margin-top: 5px;
}

.footer {
    padding: 15px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.2);
    margin-top: 20px;
}

.current-info {
    color: rgba(255, 255, 255, 0.8);
    font-size: 12px;
}

.error-message {
    color: rgba(220, 53, 69, 0.9);
    padding: 20px;
    text-align: center;
}
`;

// アプリケーション設定
App.config({
    windows: [WallpaperSelector()],
    style: css,
});

export { };