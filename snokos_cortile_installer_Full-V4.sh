#!/bin/bash
# =====================================================================
#  🚀 SnokOS - Tiling Window Manager & Tools Installer
#  Version: 2.1 (Multilingual: EN, FR, AR + Extra Packages)
#  Description: Professional installer for Cortile & tools with
#               XFCE integration, progress bar, and language selection.
# =====================================================================

# ---------- الألوان ----------
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m'

# ---------- المتغيرات العامة ----------
readonly SCRIPT_NAME="SnokOS Tiling Window Manager Installer"
readonly LOG_FILE="/tmp/snokos_cortile_install.log"
readonly CORTILE_BIN="/usr/local/bin/cortile"
readonly TOGGLE_SCRIPT="/usr/local/bin/cortile-toggle.sh"
readonly GUI_SCRIPT="/usr/local/bin/cortile-gui.sh"
readonly DESKTOP_DIR="/usr/share/applications"
readonly ICON_BASE_DIR="/usr/share/icons/hicolor"
readonly ICON_NAME="cortile"
readonly ICON_URL="https://raw.githubusercontent.com/eythaann/Seelen-UI/master/documentation/images/logo.svg"
readonly LANG_FILE="/etc/cortile/language"
readonly GUI_STRINGS_FILE="/etc/cortile/gui_strings.sh"

# ---------- قائمة الحزم المطلوبة (تمت إضافة wget, git, curl, net-tools, nala) ----------
readonly PACKAGES=(
    "wget"
    "git"
    "curl"
    "net-tools"
    "nala"
    "starship"
    "atuin"
    "lightdm-gtk-greeter-settings"
    "gnome-system-tools"
    "software-properties-gtk"
    "synaptic"
    "mugshot"
    "mate-calc"
    "menulibre"
    "blueman"
)

# =====================================================================
#  الترجمة (i18n)
# =====================================================================
declare -A MSG_EN MSG_FR MSG_AR

# --- English ---
MSG_EN[welcome]="🚀 SnokOS - Tiling Window Manager & Tools Installer"
MSG_EN[desc]="Install required tools and set up Cortile for XFCE"
MSG_EN[root_error]="❌ Please run this script as root (sudo)."
MSG_EN[de_check]="🔍 Checking desktop environment..."
MSG_EN[de_current]="   ↳ Current DE:"
MSG_EN[de_xfce]="   ✅ XFCE detected. Proceeding automatically."
MSG_EN[de_not_xfce]="   ⚠️ Current DE is not XFCE."
MSG_EN[de_confirm]="Do you want to continue anyway?"
MSG_EN[yes]="Yes"
MSG_EN[no]="No"
MSG_EN[de_cancelled]="❌ Installation cancelled by user."
MSG_EN[de_approved]="   ✅ User approved. Continuing."
MSG_EN[installing_packages]="📦 Installing required packages..."
MSG_EN[updating_repos]="   ↳ Updating repositories..."
MSG_EN[installing_pkg]="Installing:"
MSG_EN[packages_done]="Packages installation complete."
MSG_EN[progress_title]="🚀 SnokOS - Advanced Installation"
MSG_EN[progress_text]="Installing..."
MSG_EN[step]="Step"
MSG_EN[elapsed]="Elapsed:"
MSG_EN[remaining]="Remaining:"
MSG_EN[downloading_cortile]="⬇️  Downloading Cortile..."
MSG_EN[creating_toggle]="🛠️  Creating toggle script..."
MSG_EN[installing_icon]="🎨 Installing main icon..."
MSG_EN[creating_toggle_icons]="🔘 Creating toggle switch icons..."
MSG_EN[creating_gui]="🖥️  Creating graphical interface..."
MSG_EN[creating_desktop]="⚙️  Creating desktop entry..."
MSG_EN[setting_autostart]="🚀 Setting up autostart..."
MSG_EN[updating_db]="🔄 Updating databases..."
MSG_EN[launching_gui]="🎬 Launching Tiling Window Manager GUI..."
MSG_EN[success]="✅ Installation completed successfully!"
MSG_EN[open_settings]="🔹 Open Settings → Personal → Tiling Window Manager"
MSG_EN[error_imagemagick]="❌ ImageMagick installation failed. Aborting."
MSG_EN[imagemagick_ok]="   ✔ ImageMagick is ready."
MSG_EN[imagemagick_installing]="   ↳ Not installed, installing..."

# --- Français ---
MSG_FR[welcome]="🚀 SnokOS - Installateur de Tiling Window Manager & Outils"
MSG_FR[desc]="Installer les outils requis et configurer Cortile pour XFCE"
MSG_FR[root_error]="❌ Veuillez exécuter ce script en tant que root (sudo)."
MSG_FR[de_check]="🔍 Vérification de l'environnement de bureau..."
MSG_FR[de_current]="   ↳ DE actuel :"
MSG_FR[de_xfce]="   ✅ XFCE détecté. Poursuite automatique."
MSG_FR[de_not_xfce]="   ⚠️ Le DE actuel n'est pas XFCE."
MSG_FR[de_confirm]="Voulez-vous continuer quand même ?"
MSG_FR[yes]="Oui"
MSG_FR[no]="Non"
MSG_FR[de_cancelled]="❌ Installation annulée par l'utilisateur."
MSG_FR[de_approved]="   ✅ Utilisateur approuvé. Continuation."
MSG_FR[installing_packages]="📦 Installation des paquets requis..."
MSG_FR[updating_repos]="   ↳ Mise à jour des dépôts..."
MSG_FR[installing_pkg]="Installation :"
MSG_FR[packages_done]="Installation des paquets terminée."
MSG_FR[progress_title]="🚀 SnokOS - Installation avancée"
MSG_FR[progress_text]="Installation..."
MSG_FR[step]="Étape"
MSG_FR[elapsed]="Écoulé :"
MSG_FR[remaining]="Restant :"
MSG_FR[downloading_cortile]="⬇️  Téléchargement de Cortile..."
MSG_FR[creating_toggle]="🛠️  Création du script de bascule..."
MSG_FR[installing_icon]="🎨 Installation de l'icône principale..."
MSG_FR[creating_toggle_icons]="🔘 Création des icônes de bascule..."
MSG_FR[creating_gui]="🖥️  Création de l'interface graphique..."
MSG_FR[creating_desktop]="⚙️  Création de l'entrée de bureau..."
MSG_FR[setting_autostart]="🚀 Configuration du démarrage automatique..."
MSG_FR[updating_db]="🔄 Mise à jour des bases de données..."
MSG_FR[launching_gui]="🎬 Lancement de l'interface Tiling Window Manager..."
MSG_FR[success]="✅ Installation terminée avec succès !"
MSG_FR[open_settings]="🔹 Ouvrez Paramètres → Personnel → Tiling Window Manager"
MSG_FR[error_imagemagick]="❌ Échec de l'installation d'ImageMagick. Abandon."
MSG_FR[imagemagick_ok]="   ✔ ImageMagick est prêt."
MSG_FR[imagemagick_installing]="   ↳ Non installé, installation..."

# --- العربية ---
MSG_AR[welcome]="🚀 SnokOS - مثبت مدير النوافذ المتجانب والأدوات"
MSG_AR[desc]="تثبيت الأدوات المطلوبة وإعداد Cortile لواجهة XFCE"
MSG_AR[root_error]="❌ يرجى تشغيل السكريبت بصلاحيات الجذر (sudo)."
MSG_AR[de_check]="🔍 التحقق من واجهة سطح المكتب..."
MSG_AR[de_current]="   ↳ الواجهة الحالية:"
MSG_AR[de_xfce]="   ✅ تم اكتشاف XFCE. المتابعة تلقائيًا."
MSG_AR[de_not_xfce]="   ⚠️ الواجهة الحالية ليست XFCE."
MSG_AR[de_confirm]="هل تريد المتابعة على أي حال؟"
MSG_AR[yes]="نعم"
MSG_AR[no]="لا"
MSG_AR[de_cancelled]="❌ تم إلغاء التثبيت من قبل المستخدم."
MSG_AR[de_approved]="   ✅ تمت الموافقة. المتابعة."
MSG_AR[installing_packages]="📦 تثبيت الحزم المطلوبة..."
MSG_AR[updating_repos]="   ↳ تحديث المستودعات..."
MSG_AR[installing_pkg]="تثبيت:"
MSG_AR[packages_done]="اكتمل تثبيت الحزم."
MSG_AR[progress_title]="🚀 SnokOS - التثبيت المتقدم"
MSG_AR[progress_text]="جارٍ التثبيت..."
MSG_AR[step]="الخطوة"
MSG_AR[elapsed]="الوقت المنقضي:"
MSG_AR[remaining]="الوقت المتبقي:"
MSG_AR[downloading_cortile]="⬇️  تنزيل Cortile..."
MSG_AR[creating_toggle]="🛠️  إنشاء سكريبت التحكم..."
MSG_AR[installing_icon]="🎨 تثبيت الأيقونة الرئيسية..."
MSG_AR[creating_toggle_icons]="🔘 إنشاء أيقونات مفتاح التبديل..."
MSG_AR[creating_gui]="🖥️  إنشاء الواجهة الرسومية..."
MSG_AR[creating_desktop]="⚙️  إنشاء ملف الإعداد..."
MSG_AR[setting_autostart]="🚀 إعداد التشغيل التلقائي..."
MSG_AR[updating_db]="🔄 تحديث قواعد البيانات..."
MSG_AR[launching_gui]="🎬 فتح واجهة Tiling Window Manager..."
MSG_AR[success]="✅ تم التثبيت بنجاح!"
MSG_AR[open_settings]="🔹 افتح الإعدادات ← Personal ← Tiling Window Manager"
MSG_AR[error_imagemagick]="❌ فشل تثبيت ImageMagick. إيقاف التنفيذ."
MSG_AR[imagemagick_ok]="   ✔ ImageMagick جاهز."
MSG_AR[imagemagick_installing]="   ↳ غير مثبت، جارٍ التثبيت..."

# دالة الترجمة
t() {
    local key="$1"
    local lang="$2"
    case "$lang" in
        fr) echo "${MSG_FR[$key]}" ;;
        ar) echo "${MSG_AR[$key]}" ;;
        *)  echo "${MSG_EN[$key]}" ;;
    esac
}

# =====================================================================
#  دوال مساعدة
# =====================================================================

# اختيار اللغة
select_language() {
    if [ -f "$LANG_FILE" ]; then
        LANG_CODE=$(cat "$LANG_FILE")
    else
        LANG_CODE=$(zenity --list \
            --title="Select Language / Choisir la langue / اختر اللغة" \
            --column="Language" \
            --column="Code" \
            "English" "en" \
            "Français" "fr" \
            "العربية" "ar" \
            --width=300 --height=250 \
            --hide-column=2 \
            --print-column=2 \
            2>/dev/null)
        [ -z "$LANG_CODE" ] && LANG_CODE="en"
        mkdir -p "$(dirname "$LANG_FILE")"
        echo "$LANG_CODE" > "$LANG_FILE"
    fi
    export LANG_CODE
}

# عرض شريط التقدم المتقدم
show_progress_bar() {
    local title="$1"
    local total_steps="$2"
    local start_time=$(date +%s)
    (
        for ((i = 1; i <= total_steps; i++)); do
            local elapsed=$(( $(date +%s) - start_time ))
            local remaining=$(( (elapsed * (total_steps - i)) / i ))
            local percent=$(( i * 100 / total_steps ))
            echo "$percent"
            echo "# $(t progress_text $LANG_CODE)"
            echo "# $(t step $LANG_CODE) $i / $total_steps"
            echo "# $(t elapsed $LANG_CODE) ${elapsed}s"
            echo "# $(t remaining $LANG_CODE) ~${remaining}s"
            sleep 0.3
        done
        echo "100"
        echo "# $(t success $LANG_CODE)"
        sleep 1
    ) | zenity --progress \
        --title="$title" \
        --text="$(t progress_text $LANG_CODE)" \
        --percentage=0 \
        --auto-close \
        --width=500 \
        --height=200 \
        --time-remaining \
        --no-cancel \
        2>/dev/null
}

# التحقق من واجهة سطح المكتب
check_desktop_environment() {
    echo -e "${CYAN}$(t de_check $LANG_CODE)${NC}"
    local current_de="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-unknown}}"
    echo -e "${WHITE}$(t de_current $LANG_CODE) ${PURPLE}${current_de}${NC}"
    if [[ "$current_de" == *"XFCE"* ]] || [[ "$current_de" == *"xfce"* ]]; then
        echo -e "${GREEN}$(t de_xfce $LANG_CODE)${NC}"
        return 0
    else
        echo -e "${YELLOW}$(t de_not_xfce $LANG_CODE)${NC}"
        if command -v zenity &>/dev/null; then
            zenity --question \
                --title="⚠️ $(t de_confirm $LANG_CODE)" \
                --text="$(t de_not_xfce $LANG_CODE)\n\n$(t de_confirm $LANG_CODE)" \
                --width=400 \
                --ok-label="$(t yes $LANG_CODE)" \
                --cancel-label="$(t no $LANG_CODE)" \
                2>/dev/null
            if [ $? -ne 0 ]; then
                echo -e "${RED}$(t de_cancelled $LANG_CODE)${NC}"
                exit 0
            fi
        else
            read -rp "   $(t de_confirm $LANG_CODE) (y/n): " confirm
            [[ "$confirm" != "y" && "$confirm" != "Y" ]] && { echo -e "${RED}$(t de_cancelled $LANG_CODE)${NC}"; exit 0; }
        fi
        echo -e "${GREEN}$(t de_approved $LANG_CODE)${NC}"
        return 0
    fi
}

# تثبيت الحزم
install_packages() {
    echo -e "${CYAN}$(t installing_packages $LANG_CODE)${NC}"
    echo -e "${WHITE}$(t updating_repos $LANG_CODE)${NC}"
    apt update -qq 2>/dev/null

    (
        for i in "${!PACKAGES[@]}"; do
            pkg="${PACKAGES[$i]}"
            percent=$(( (i + 1) * 100 / ${#PACKAGES[@]} ))
            echo "$percent"
            echo "# $(t installing_pkg $LANG_CODE) ${pkg}"
            apt install -y "$pkg" 2>/dev/null || true
        done
        echo "100"
        echo "# $(t packages_done $LANG_CODE)"
    ) | zenity --progress \
        --title="📦 $(t installing_packages $LANG_CODE)" \
        --text="$(t installing_pkg $LANG_CODE)..." \
        --percentage=0 \
        --auto-close \
        --width=500 \
        --time-remaining \
        2>/dev/null
}

# تثبيت الأيقونة الرئيسية
install_icon() {
    echo -e "${CYAN}$(t installing_icon $LANG_CODE)${NC}"
    local temp_dir=$(mktemp -d)
    if wget -qO "$temp_dir/icon.svg" "$ICON_URL" 2>/dev/null; then
        for size in 16 22 24 32 48 64 128 256 512; do
            mkdir -p "${ICON_BASE_DIR}/${size}x${size}/apps"
            rsvg-convert -w $size -h $size "$temp_dir/icon.svg" \
                -o "${ICON_BASE_DIR}/${size}x${size}/apps/${ICON_NAME}.png" 2>/dev/null || \
            convert -background none -resize ${size}x${size} \
                "$temp_dir/icon.svg" \
                "${ICON_BASE_DIR}/${size}x${size}/apps/${ICON_NAME}.png" 2>/dev/null || true
        done
        mkdir -p "${ICON_BASE_DIR}/scalable/apps"
        cp "$temp_dir/icon.svg" "${ICON_BASE_DIR}/scalable/apps/${ICON_NAME}.svg"
    fi
    rm -rf "$temp_dir"
}

# إنشاء أيقونات مفتاح التبديل
create_toggle_icons() {
    echo -e "${CYAN}$(t creating_toggle_icons $LANG_CODE)${NC}"
    local toggle_dir="${ICON_BASE_DIR}/128x128/apps"
    mkdir -p "$toggle_dir"
    convert -size 80x40 xc:none \
        -fill "#3b82f6" -draw "roundrectangle 0,0 79,39 20,20" \
        -fill white -draw "circle 60,20 60,8" \
        "$toggle_dir/cortile-toggle-on.png" 2>/dev/null || true
    convert -size 80x40 xc:none \
        -fill "#94a3b8" -draw "roundrectangle 0,0 79,39 20,20" \
        -fill white -draw "circle 20,20 20,8" \
        "$toggle_dir/cortile-toggle-off.png" 2>/dev/null || true
}

# إنشاء سكريبت التحكم
create_toggle_script() {
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
}

# إنشاء ملف ترجمات الواجهة الرسومية
create_gui_strings() {
    mkdir -p "$(dirname "$GUI_STRINGS_FILE")"
    case "$LANG_CODE" in
        fr)
            cat > "$GUI_STRINGS_FILE" << 'EOF'
GUI_TITLE="Tiling Window Manager"
GUI_SUBTITLE="Gestion automatique des fenêtres pour XFCE"
GUI_STATUS_LABEL="Statut"
GUI_STATUS_ENABLED="●  ACTIVÉ"
GUI_STATUS_DISABLED="●  DÉSACTIVÉ"
GUI_SHORTCUTS_HEADING="⌨  Raccourcis clavier"
GUI_SHORTCUT_TOGGLE="Basculer le tiling"
GUI_SHORTCUT_UNTILE="Détuiler l'espace"
GUI_SHORTCUT_CYCLE="Changer de disposition"
GUI_SHORTCUT_FULLSCREEN="Disposition plein écran"
GUI_SHORTCUT_DECORATIONS="Basculer les décorations"
GUI_SHORTCUT_ADD="Ajouter une fenêtre"
GUI_SHORTCUT_REMOVE="Retirer une fenêtre"
GUI_BTN_ENABLE="Activer le Tiling"
GUI_BTN_DISABLE="Désactiver le Tiling"
GUI_BTN_CLOSE="Fermer"
EOF
            ;;
        ar)
            cat > "$GUI_STRINGS_FILE" << 'EOF'
GUI_TITLE="مدير النوافذ المتجانب"
GUI_SUBTITLE="تجانب تلقائي للنوافذ في XFCE"
GUI_STATUS_LABEL="الحالة"
GUI_STATUS_ENABLED="●  مُفعّل"
GUI_STATUS_DISABLED="●  مُعطّل"
GUI_SHORTCUTS_HEADING="⌨  اختصارات لوحة المفاتيح"
GUI_SHORTCUT_TOGGLE="تبديل التجانب"
GUI_SHORTCUT_UNTILE="إلغاء تجانب مساحة العمل"
GUI_SHORTCUT_CYCLE="تبديل التخطيطات"
GUI_SHORTCUT_FULLSCREEN="تخطيط ملء الشاشة"
GUI_SHORTCUT_DECORATIONS="تبديل زخارف النوافذ"
GUI_SHORTCUT_ADD="إضافة نافذة"
GUI_SHORTCUT_REMOVE="إزالة نافذة"
GUI_BTN_ENABLE="تفعيل التجانب"
GUI_BTN_DISABLE="تعطيل التجانب"
GUI_BTN_CLOSE="إغلاق"
EOF
            ;;
        *)
            cat > "$GUI_STRINGS_FILE" << 'EOF'
GUI_TITLE="Tiling Window Manager"
GUI_SUBTITLE="Automatic window tiling for XFCE"
GUI_STATUS_LABEL="Status"
GUI_STATUS_ENABLED="●  ENABLED"
GUI_STATUS_DISABLED="●  DISABLED"
GUI_SHORTCUTS_HEADING="⌨  Keyboard Shortcuts"
GUI_SHORTCUT_TOGGLE="Toggle tiling"
GUI_SHORTCUT_UNTILE="Untile workspace"
GUI_SHORTCUT_CYCLE="Cycle layouts"
GUI_SHORTCUT_FULLSCREEN="Fullscreen layout"
GUI_SHORTCUT_DECORATIONS="Toggle decorations"
GUI_SHORTCUT_ADD="Add window"
GUI_SHORTCUT_REMOVE="Remove window"
GUI_BTN_ENABLE="Enable Tiling"
GUI_BTN_DISABLE="Disable Tiling"
GUI_BTN_CLOSE="Close"
EOF
            ;;
    esac
}

# إنشاء الواجهة الرسومية
create_gui_script() {
    echo -e "${CYAN}$(t creating_gui $LANG_CODE)${NC}"
    cat > "$GUI_SCRIPT" << 'GUIEOF'
#!/bin/bash
TOGGLE_SCRIPT="/usr/local/bin/cortile-toggle.sh"
STRINGS_FILE="/etc/cortile/gui_strings.sh"

if [ -f "$STRINGS_FILE" ]; then
    source "$STRINGS_FILE"
else
    GUI_TITLE="Tiling Window Manager"
    GUI_SUBTITLE="Automatic window tiling for XFCE"
    GUI_STATUS_LABEL="Status"
    GUI_STATUS_ENABLED="●  ENABLED"
    GUI_STATUS_DISABLED="●  DISABLED"
    GUI_SHORTCUTS_HEADING="⌨  Keyboard Shortcuts"
    GUI_SHORTCUT_TOGGLE="Toggle tiling"
    GUI_SHORTCUT_UNTILE="Untile workspace"
    GUI_SHORTCUT_CYCLE="Cycle layouts"
    GUI_SHORTCUT_FULLSCREEN="Fullscreen layout"
    GUI_SHORTCUT_DECORATIONS="Toggle decorations"
    GUI_SHORTCUT_ADD="Add window"
    GUI_SHORTCUT_REMOVE="Remove window"
    GUI_BTN_ENABLE="Enable Tiling"
    GUI_BTN_DISABLE="Disable Tiling"
    GUI_BTN_CLOSE="Close"
fi

if [[ "$(cat /etc/cortile/language 2>/dev/null)" == "ar" ]]; then
    export GTK_TEXT_DIR_RTL=1
    YAD_RTL="--text-direction=rtl"
else
    YAD_RTL=""
fi

if ! command -v yad &>/dev/null; then
    xfce4-terminal --title="$GUI_TITLE" \
        --command="bash -c 'echo \"⚠️ yad is not installed. Run: sudo apt install yad\"; read'"
    exit 1
fi

while true; do
    if [ -f /tmp/cortile.pid ] && kill -0 $(cat /tmp/cortile.pid) 2>/dev/null; then
        STATE="on"
        STATUS="$GUI_STATUS_ENABLED"
        IMG="cortile-toggle-on"
        BTN="$GUI_BTN_DISABLE"
    else
        STATE="off"
        STATUS="$GUI_STATUS_DISABLED"
        IMG="cortile-toggle-off"
        BTN="$GUI_BTN_ENABLE"
    fi

    TEXT="<span size='15000' weight='bold' foreground='#0f172a'>$GUI_TITLE</span>
<span size='9500' foreground='#64748b'>$GUI_SUBTITLE</span>

<span size='10000' foreground='#475569'>$GUI_STATUS_LABEL</span>     <span foreground='#10b981' weight='bold' size='12000'>$STATUS</span>

<span foreground='#cbd5e1'>──────────────────────────────────────────</span>

<span size='11000' weight='bold' foreground='#0f172a'>$GUI_SHORTCUTS_HEADING</span>

<span font_family='monospace' size='10000'>
  <b>Ctrl+Shift+T</b>        <span foreground='#475569'>$GUI_SHORTCUT_TOGGLE</span>
  <b>Ctrl+Shift+U</b>        <span foreground='#475569'>$GUI_SHORTCUT_UNTILE</span>
  <b>Ctrl+Shift+L</b>        <span foreground='#475569'>$GUI_SHORTCUT_CYCLE</span>
  <b>Ctrl+Shift+Space</b>    <span foreground='#475569'>$GUI_SHORTCUT_FULLSCREEN</span>
  <b>Ctrl+Shift+D</b>        <span foreground='#475569'>$GUI_SHORTCUT_DECORATIONS</span>
  <b>Ctrl+Shift+A</b>        <span foreground='#475569'>$GUI_SHORTCUT_ADD</span>
  <b>Ctrl+Shift+R</b>        <span foreground='#475569'>$GUI_SHORTCUT_REMOVE</span>
</span>"

    yad --title="$GUI_TITLE" \
        --window-icon="cortile" \
        --width=470 \
        --center \
        --borders=12 \
        --text="$TEXT" \
        --image="$IMG" \
        --image-on-top \
        --button="$BTN:0" \
        --button="$GUI_BTN_CLOSE:1" \
        --skip-taskbar \
        $YAD_RTL

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
}

# إنشاء ملف .desktop
create_desktop_entry() {
    echo -e "${CYAN}$(t creating_desktop $LANG_CODE)${NC}"
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
}

# إعداد التشغيل التلقائي
setup_autostart() {
    echo -e "${CYAN}$(t setting_autostart $LANG_CODE)${NC}"
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
}

# =====================================================================
#  الدالة الرئيسية
# =====================================================================
main() {
    clear
    select_language

    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                                                              ║"
    echo "║   $(t welcome $LANG_CODE)"
    echo "║                                                              ║"
    echo "║   $(t desc $LANG_CODE)"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}$(t root_error $LANG_CODE)${NC}"
        exit 1
    fi

    check_desktop_environment
    install_packages
    show_progress_bar "$(t progress_title $LANG_CODE)" 10

    echo -e "${CYAN}$(t downloading_cortile $LANG_CODE)${NC}"
    LATEST_URL=$(curl -s https://api.github.com/repos/leukipp/cortile/releases/latest | \
        jq -r '.assets[] | select(.name | contains("linux_amd64.tar.gz")) | .browser_download_url')
    [ -z "$LATEST_URL" ] && LATEST_URL="https://github.com/leukipp/cortile/releases/latest/download/cortile_linux_amd64.tar.gz"
    mkdir -p /opt/cortile
    wget -qO- "$LATEST_URL" | tar -xvz -C /opt/cortile 2>/dev/null
    cp /opt/cortile/cortile "$CORTILE_BIN"
    chmod +x "$CORTILE_BIN"

    if ! command -v convert &>/dev/null; then
        echo -e "${YELLOW}$(t imagemagick_installing $LANG_CODE)${NC}"
        apt install -y imagemagick >/dev/null 2>&1 || true
    fi
    if ! command -v convert &>/dev/null; then
        echo -e "${RED}$(t error_imagemagick $LANG_CODE)${NC}"
        exit 1
    fi
    echo -e "${GREEN}$(t imagemagick_ok $LANG_CODE)${NC}"

    echo -e "${CYAN}$(t creating_toggle $LANG_CODE)${NC}"
    create_toggle_script

    echo -e "${CYAN}$(t installing_icon $LANG_CODE)${NC}"
    install_icon

    echo -e "${CYAN}$(t creating_toggle_icons $LANG_CODE)${NC}"
    create_toggle_icons

    echo -e "${CYAN}$(t creating_gui $LANG_CODE)${NC}"
    create_gui_script

    echo -e "${CYAN}$(t creating_desktop $LANG_CODE)${NC}"
    create_desktop_entry

    echo -e "${CYAN}$(t setting_autostart $LANG_CODE)${NC}"
    setup_autostart

    echo -e "${CYAN}$(t updating_db $LANG_CODE)${NC}"
    gtk-update-icon-cache -f -t "${ICON_BASE_DIR}" >/dev/null 2>&1 || true
    update-desktop-database >/dev/null 2>&1 || true

    create_gui_strings

    if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
        USER_HOME=$(eval echo "~$SUDO_USER")
        TARGET_DISPLAY="${DISPLAY:-:0}"
        echo -e "${GREEN}$(t launching_gui $LANG_CODE)${NC}"
        sleep 2
        sudo -u "$SUDO_USER" \
            DISPLAY="$TARGET_DISPLAY" \
            XAUTHORITY="$USER_HOME/.Xauthority" \
            "$GUI_SCRIPT" &
    fi

    echo ""
    echo -e "${GREEN}$(t success $LANG_CODE)${NC}"
    echo -e "${WHITE}$(t open_settings $LANG_CODE)${NC}"
    echo ""
}

main "$@"