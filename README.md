<!-- ═══════════════════════════════════════════════════════════════════ -->
<!--           🚀 SnokOS - Tiling Window Manager Installer               -->
<!-- ═══════════════════════════════════════════════════════════════════ -->

<div align="center">

<img src="https://raw.githubusercontent.com/eythaann/Seelen-UI/master/documentation/images/logo.svg" alt="SnokOS Logo" width="140" height="140"/>

# 🚀 SnokOS - Tiling Window Manager Installer

### ✨ مثبّت احترافي متعدد اللغات لـ Cortile على واجهة XFCE

<p>
  <a href="https://github.com/SnokOS/SnokOS---Tiling-Window-Manager-XFCE">
    <img src="https://img.shields.io/badge/repo-SnokOS%2FTiling--Window--Manager-181717?style=for-the-badge&logo=github" alt="Repository"/>
  </a>
  <img src="https://img.shields.io/badge/version-2.1-blue?style=for-the-badge&logo=github" alt="Version"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License"/>
  <img src="https://img.shields.io/badge/platform-Linux-orange?style=for-the-badge&logo=linux" alt="Platform"/>
  <img src="https://img.shields.io/badge/desktop-XFCE-2284f2?style=for-the-badge&logo=xfce" alt="XFCE"/>
  <img src="https://img.shields.io/badge/languages-EN%20%7C%20FR%20%7C%20AR-purple?style=for-the-badge" alt="Languages"/>
</p>

<p>
  <a href="#-المميزات">المميزات</a> •
  <a href="#-لقطات-الشاشة">لقطات الشاشة</a> •
  <a href="#-التثبيت">التثبيت</a> •
  <a href="#-الاستخدام">الاستخدام</a> •
  <a href="#-اختصارات-لوحة-المفاتيح">الاختصارات</a> •
  <a href="#-المساهمة">المساهمة</a>
</p>

</div>

---

## 🌟 نظرة عامة

**SnokOS Installer** هو سكريبت احترافي يقوم بتثبيت وإعداد **Cortile** (مدير نوافذ متجانب تلقائيًا) على واجهة **XFCE**، بالإضافة إلى مجموعة من الأدوات الأساسية التي يحتاجها أي مستخدم Linux.

يدعم السكريبت **ثلاث لغات** (الإنجليزية، الفرنسية، العربية) مع واجهة رسومية أنيقة، شريط تقدم متقدم، وأيقونات تبديل بأسلوب iOS.

---

## 🎯 المميزات

<table>
<tr>
<td width="50%">

### 🎨 واجهة رسومية أنيقة
- نافذة صغيرة ومدمجة
- مفتاح تبديل بأسلوب iOS
- ألوان توضيحية (أخضر/أحمر)
- عرض فوري للحالة

</td>
<td width="50%">

### 🌍 دعم متعدد اللغات
- 🇬🇧 الإنجليزية (افتراضي)
- 🇫🇷 الفرنسية
- 🇸🇦 العربية (مع دعم RTL)

</td>
</tr>
<tr>
<td width="50%">

### 📦 تثبيت تلقائي
- 15+ حزمة أساسية
- شريط تقدم مع الوقت المتبقي
- تحقق تلقائي من التبعيات
- دعم ImageMagick

</td>
<td width="50%">

### ⚙️ تكامل كامل مع XFCE
- إضافة في مدير الإعدادات
- تشغيل تلقائي للمستخدمين الجدد
- أيقونة مخصصة عالية الدقة
- سكريبت تحكم (Toggle)

</td>
</tr>
</table>

---

## 📸 لقطات الشاشة

<div align="center">

### 🖥️ الواجهة الرسومية الرئيسية

![Tiling Window Manager UI](docs/screenshots/ui-preview.png)

*نافذة التحكم الأنيقة مع مفتاح التبديل الفوري وعرض الاختصارات*

### 🔘 أيقونات مفتاح التبديل

| الحالة | الأيقونة |
|:---:|:---:|
| **مُفعّل** | ![ON](https://img.shields.io/badge/●-ENABLED-10b981?style=flat-square) |
| **مُعطّل** | ![OFF](https://img.shields.io/badge/●-DISABLED-ef4444?style=flat-square) |

</div>

---

## ⚡ التثبيت بأمر واحد

<div align="center">

### 🚀 انسخ والصق — يتم التثبيت تلقائيًا

</div>

```bash
curl -sSL https://raw.githubusercontent.com/SnokOS/SnokOS---Tiling-Window-Manager-XFCE/main/install.sh | sudo bash