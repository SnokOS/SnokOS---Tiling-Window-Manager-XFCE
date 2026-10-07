#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  🚀 SnokOS Tiling Window Manager - Quick Installer
#  ═══════════════════════════════════════════════════════════
#  الاستخدام:
#     curl -sSL https://raw.githubusercontent.com/SnokOS/\
#     SnokOS---Tiling-Window-Manager-XFCE/main/install.sh | sudo bash
# ═══════════════════════════════════════════════════════════

set -e

# 🎨 الألوان
readonly C='\033[0;36m'
readonly G='\033[0;32m'
readonly Y='\033[1;33m'
readonly R='\033[0;31m'
readonly NC='\033[0m'

# 🌐 روابط
readonly REPO="SnokOS/SnokOS---Tiling-Window-Manager-XFCE"
readonly BRANCH="main"
readonly MAIN_SCRIPT_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/snokos_cortile_installer.sh"
readonly TMP_SCRIPT="/tmp/snokos_installer_$$.sh"

# 🖨️ دالة عرض الشعار
print_banner() {
    clear
    echo -e "${C}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🚀  SnokOS - Tiling Window Manager Installer               ║
║                                                              ║
║   🌐  github.com/SnokOS/SnokOS---Tiling-Window-Manager-XFCE  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# 🔍 التحقق من الصلاحيات
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${R}❌ يرجى تشغيل السكريبت بصلاحيات الجذر (sudo).${NC}"
        echo -e "${Y}💡 استخدم الأمر التالي:${NC}"
        echo -e "${C}   curl -sSL https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh | sudo bash${NC}"
        exit 1
    fi
}

# 📦 التحقق من وجود curl
ensure_curl() {
    if ! command -v curl &>/dev/null; then
        echo -e "${Y}📦 curl غير مثبت، جارٍ التثبيت...${NC}"
        apt update -qq && apt install -y curl >/dev/null 2>&1
    fi
}

# ⬇️ تنزيل السكريبت الرئيسي
download_main_script() {
    echo -e "${C}⬇️  تنزيل السكريبت الرئيسي...${NC}"
    if ! curl -sSL "$MAIN_SCRIPT_URL" -o "$TMP_SCRIPT"; then
        echo -e "${R}❌ فشل تنزيل السكريبت. تحقق من اتصالك بالإنترنت.${NC}"
        exit 1
    fi
    chmod +x "$TMP_SCRIPT"
    echo -e "${G}✅ تم التنزيل بنجاح.${NC}"
}

# 🚀 تشغيل السكريبت
run_installer() {
    echo -e "${C}🚀 تشغيل المثبّت...${NC}"
    echo -e "${C}══════════════════════════════════════════════════════════════${NC}"
    echo ""

    bash "$TMP_SCRIPT"

    # تنظيف تلقائي
    rm -f "$TMP_SCRIPT"
}

# 🎯 التنفيذ الرئيسي
main() {
    print_banner
    check_root
    ensure_curl
    download_main_script
    run_installer
}

main "$@"