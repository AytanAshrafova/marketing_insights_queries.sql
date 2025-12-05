Marketing Insights for E-Commerce
-------------------------------------------
Layihə Haqqında
-------------------------
Bu layihə e-commerce biznesində satış performansını, müştəri davranışlarını və marketinq xərclərinin təsirini analiz etmək məqsədilə hazırlanmışdır. Raw CSV datasetləri əvvəlcə PostgreSQL-ə yüklənmiş, burada data cleaning, transformasiya və analitik SQL sorğuları icra olunmuşdur. Satış trendləri, RFM, LTV, cohort analizi, next purchase day və market basket analizi kimi əsas metriklər SQL vasitəsilə hesablanmışdır.
Analiz nəticələri daha sonra Power BI-də interaktiv dashboard formatında vizuallaşdırılmışdır. Dashboardlar satış və gəlir dinamikasını, müştəri seqmentlərini, marketinq ROI-ni və cross-selling imkanlarını aydın şəkildə göstərir. Bu analitik panel biznes üçün qərar qəbuletmədə real dəyər yaradan insights təqdim edir.

-------------------------------------------------------------
Layihənin Məqsədi

 Satış və gəlir performansını təhlil etmək
 Müştəri segmentasiyasını müəyyənləşdirmək (RFM & LTV)
 Marketinq xərclərinin effektivliyini ölçmək
 Məhsul və kateqoriyalara görə satış trendini araşdırmaq

-----------------------------------------------
Datasetlər
Dataset	Təsviri
Customers_Data.csv	  Müştəri məlumatları
Online_Sales.csv	   Tranzaksiya dataları
Discount_Coupon.csv	  Kupon və endirim məlumatları
Marketing_Spend.csv   	Marketinq xərcləri
Tax_Amount.csv         	GST faizləri

-----------------------------------------------
 Analitik Bloklar
Satış və Gəlir Analizi

Aylıq satış və gəlir
Məhsul/kateqoriya üzrə performans
Endirimlərin təsiri
Pik satış dövrləri
Invoice Value = ((Quantity * Avg_Price) * (1 - Discount_pct)) * (1 + GST) + Delivery_Charges

------------------------------------------------
 Müştəri Segmentasiyası (RFM & LTV)

Recency, Frequency, Monetary dəyərləri
Premium / Gold / Silver / Standard seqmentləri
LTV hesablaması

-------------------------------------------------
 Next Purchase Day

0–30 gün
30–60 gün
60+ gün

---------------
Cohort Analizi
İlk alış ayına görə cohort
Retention təhlili

---------------------------
 Market Basket Analizi

Birlikdə alınan məhsullar
Cross-sell və bundle fürsətləri

-----------------------------------


 İstifadə Edilən Texnologiyalar

PostgreSQL — Sorğuların yazılması və təhlil

Power BI — Dashboardlar və vizuallaşdırma

CSV — Raw data formatı

--------------------------------------

 Business Impact

RFM & LTV nəticələrinə əsasən hədəf kampaniyalarının optimallaşması

Endirimlərin təsirinin daha dəqiq ölçülməsi

Retention və satış artımına yönəlik qərarların formalaşması

Cross-selling imkanlarının aşkarlanması
