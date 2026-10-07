#!/bin/bash
# ======================================================
#  Cortile Auto-Installer & XFCE Integration
#  Version: 5.0 (Clean Modern UI + Auto Launch)
# ======================================================

set -e

# ---------- متغيرات ----------
CORTILE_DIR="/opt/cortile"
CORTILE_BIN="/usr/local/bin/cortile"
TOGGLE_SCRIPT="/usr/local/bin/cortile-toggle.sh"
GUI_SCRIPT="/usr/local/bin/cortile-gui.sh"
DESKTOP_DIR="/usr/share/applications"
ICON_BASE_DIR="/usr/share/icons/hicolor"
ICON_NAME="cortile"
ICON_URL="https://raw.githubusercontent.com/eythaann/Seelen-UI/master/documentation/images/logo.svg"
# -----------------------------

echo "🔍 [1/12] التحقق من الصلاحيات..."
[ "$EUID" -ne 0 ] && { echo "❌ شغّل السكريبت بـ sudo."; exit 1; }

echo "📦 [2/12] تثبيت التبعيات الأساسية..."
apt update -qq
apt install -y wget curl tar jq yad librsvg2-bin >/dev/null 2>&1 || true

# --- التحقق من ImageMagick ---
echo "🖼️  [3/12] التحقق من ImageMagick..."
if ! command -v convert &>/dev/null; then
    echo "   ↳ غير مثبت، جارٍ التثبيت..."
    apt install -y imagemagick >/dev/null 2>&1 || true
fi
if ! command -v convert &>/dev/null; then
    echo "❌ فشل تثبيت ImageMagick. أوقف التنفيذ."
    exit 1
fi
echo "   ✔ ImageMagick جاهز."

echo "⬇️  [4/12] تنزيل Cortile..."
LATEST_URL=$(curl -s https://api.github.com/repos/leukipp/cortile/releases/latest | jq -r '.assets[] | select(.name | contains("linux_amd64.tar.gz")) | .browser_download_url')
[ -z "$LATEST_URL" ] && LATEST_URL="https://github.com/leukipp/cortile/releases/latest/download/cortile_linux_amd64.tar.gz"
mkdir -p "$CORTILE_DIR"
wget -qO- "$LATEST_URL" | tar -xvz -C "$CORTILE_DIR"

echo "📂 [5/12] تثبيت الملف التنفيذي..."
cp "$CORTILE_DIR/cortile" "$CORTILE_BIN"
chmod +x "$CORTILE_BIN"

echo "🛠️  [6/12] سكريبت التحكم (Toggle)..."
cat > "$TOGGLE_SCRIPT" << 'EOF'
#!/bin/bash
CORTILE_BIN="/usr/local/bin/cortile"
PID_FILE="/tmp/cortile.pid"
case "$1" in
    start)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "already running"
        else
            nohup "$CORTILE_BIN" > /tmp/cortile.log 2>&1 &
            echo $! > "$PID_FILE"
        fi ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            kill $(cat "$PID_FILE") 2>/dev/null
            rm -f "$PID_FILE"
        fi ;;
    status)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "running"; exit 0
        else echo "stopped"; exit 1; fi ;;
    toggle)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            "$0" stop
        else "$0" start; fi ;;
    *) echo "Usage: $0 {start|stop|status|toggle}"; exit 1 ;;
esac
EOF
chmod +x "$TOGGLE_SCRIPT"

# --- الأيقونة الرئيسية ---
echo "🎨 [7/12] تنزيل الأيقونة الرئيسية..."
TEMP_DIR=$(mktemp -d)
wget -qO "$TEMP_DIR/icon.svg" "$ICON_URL"
for size in 16 22 24 32 48 64 128 256 512; do
    mkdir -p "${ICON_BASE_DIR}/${size}x${size}/apps"
    rsvg-convert -w $size -h $size "$TEMP_DIR/icon.svg" -o "${ICON_BASE_DIR}/${size}x${size}/apps/${ICON_NAME}.png" 2>/dev/null || \
    convert -background none -resize ${size}x${size} "$TEMP_DIR/icon.svg" "${ICON_BASE_DIR}/${size}x${size}/apps/${ICON_NAME}.png" 2>/dev/null || true
done
mkdir -p "${ICON_BASE_DIR}/scalable/apps"
cp "$TEMP_DIR/icon.svg" "${ICON_BASE_DIR}/scalable/apps/${ICON_NAME}.svg"
rm -rf "$TEMP_DIR"

# --- أيقونات مفتاح التبديل (بحجم صغير نظيف) ---
echo "🔘 [8/12] إنشاء أيقونات مفتاح التبديل..."
TOGGLE_ICON_DIR="${ICON_BASE_DIR}/128x128/apps"
mkdir -p "$TOGGLE_ICON_DIR"

# مفتاح ON (أزرق - دائرة يمين)
convert -size 80x40 xc:none \
    -fill "#3b82f6" -draw "roundrectangle 0,0 79,39 20,20" \
    -fill white -draw "circle 60,20 60,8" \
    "$TOGGLE_ICON_DIR/cortile-toggle-on.png"

# مفتاح OFF (رمادي - دائرة يسار)
convert -size 80x40 xc:none \
    -fill "#94a3b8" -draw "roundrectangle 0,0 79,39 20,20" \
    -fill white -draw "circle 20,20 20,8" \
    "$TOGGLE_ICON_DIR/cortile-toggle-off.png"

# --- واجهة المستخدم الرسومية ---
echo "🖥️  [9/12] إنشاء واجهة المستخدم الرسومية..."
cat > "$GUI_SCRIPT" << 'GUIEOF'
#!/bin/bash
# cortile-gui.sh - Compact Modern UI

TOGGLE_SCRIPT="/usr/local/bin/cortile-toggle.sh"

if ! command -v yad &>/dev/null; then
    xfce4-terminal --title="Tiling Window Manager" \
        --command="bash -c 'echo \"⚠️ yad غير مثبت. نفّذ: sudo apt install yad\"; read'"
    exit 1
fi

while true; do

    # ---- تحديد الحالة ----
    if [ -f /tmp/cortile.pid ] && kill -0 $(cat /tmp/cortile.pid) 2>/dev/null; then
        STATE="on"
        STATUS="<span foreground='#10b981' weight='bold' size='12000'>●  ENABLED</span>"
        IMG="cortile-toggle-on"
        BTN="Disable Tiling"
    else
        STATE="off"
        STATUS="<span foreground='#ef4444' weight='bold' size='12000'>●  DISABLED</span>"
        IMG="cortile-toggle-off"
        BTN="Enable Tiling"
    fi

    # ---- نص الواجهة ----
    TEXT="<span size='15000' weight='bold' foreground='#0f172a'>Tiling Window Manager</span>
<span size='9500' foreground='#64748b'>Automatic window tiling for XFCE</span>

<span size='10000' foreground='#475569'>Status</span>     $STATUS

<span foreground='#cbd5e1'>──────────────────────────────────────────</span>

<span size='11000' weight='bold' foreground='#0f172a'>⌨  Keyboard Shortcuts</span>

<span font_family='monospace' size='10000'>
  <b>Ctrl+Shift+T</b>        <span foreground='#475569'>Toggle tiling</span>
  <b>Ctrl+Shift+U</b>        <span foreground='#475569'>Untile workspace</span>
  <b>Ctrl+Shift+L</b>        <span foreground='#475569'>Cycle layouts</span>
  <b>Ctrl+Shift+Space</b>    <span foreground='#475569'>Fullscreen layout</span>
  <b>Ctrl+Shift+D</b>        <span foreground='#475569'>Toggle decorations</span>
  <b>Ctrl+Shift+A</b>        <span foreground='#475569'>Add window</span>
  <b>Ctrl+Shift+R</b>        <span foreground='#475569'>Remove window</span>
</span>"

    # ---- عرض النافذة ----
    yad --title="Tiling Window Manager" \
        --window-icon="cortile" \
        --width=470 \
        --center \
        --borders=12 \
        --text="$TEXT" \
        --image="$IMG" \
        --image-on-top \
        --button="$BTN:0" \
        --button="Close:1" \
        --skip-taskbar

    CODE=$?
    if [ $CODE -eq 0 ]; then
        "$TOGGLE_SCRIPT" toggle
        sleep 0.3
        continue
    else
        break
    fi
done
GUIEOF
chmod +x "$GUI_SCRIPT"

# --- ملف .desktop ---
echo "⚙️  [10/12] إنشاء ملف الإعداد في XFCE..."
rm -f "${DESKTOP_DIR}/cortile-settings.desktop"
rm -f "${DESKTOP_DIR}/cortile-shortcuts.desktop"

cat > "${DESKTOP_DIR}/cortile-settings.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Tiling Window Manager
Comment=Manage Cortile auto-tiling and view keyboard shortcuts
Icon=${ICON_NAME}
Exec=${GUI_SCRIPT}
Terminal=false
Categories=XFCE;GTK;Settings;DesktopSettings;X-XFCE-SettingsDialog;X-XFCE-PersonalSettings;
OnlyShowIn=XFCE;
EOF

echo "🔄 [11/12] تحديث قواعد البيانات..."
gtk-update-icon-cache -f -t "${ICON_BASE_DIR}" >/dev/null 2>&1 || true
update-desktop-database >/dev/null 2>&1 || true

echo "🚀 [12/12] إعداد التشغيل التلقائي..."
cat > "/etc/xdg/autostart/cortile.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Cortile
Comment=Auto tiling window manager
Exec=sh -c "sleep 5 && ${CORTILE_BIN}"
Terminal=false
Hidden=false
OnlyShowIn=XFCE;
X-GNOME-Autostart-enabled=true
EOF

echo ""
echo "✅ تم التثبيت بنجاح!"
echo ""
echo "🔹 افتح الإعدادات ← Personal ← Tiling Window Manager"

# --- تشغيل الواجهة تلقائيًا بعد التثبيت ---
if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
    TARGET_DISPLAY="${DISPLAY:-:0}"
    echo ""
    echo "🎬 فتح واجهة Tiling Window Manager تلقائيًا..."
    sleep 2
    sudo -u "$SUDO_USER" \
        DISPLAY="$TARGET_DISPLAY" \
        XAUTHORITY="$USER_HOME/.Xauthority" \
        "$GUI_SCRIPT" &
fi