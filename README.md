 Marketing Insights for E-Commerce
 
 Layihə Haqqında
Bu layihə, e-commerce şirkətinin satış, müştəri davranışı və marketinq xərcləri üzrə SQL əsaslı analitik təhlilini əhatə edir. PostgreSQL istifadə edilərək tranzaksiya səviyyəsində analiz aparılmış, satış tendensiyaları, müştəri dəyərləri, marketinq efekti və gəlir mənbələri dəqiq şəkildə müəyyən edilmişdir.

 Layihənin Məqsədi
 Satış və gəlir performansını izləmək
 Müştəri segmentasiyasını müəyyənləşdirmək (RFM & LTV)
 Marketinq xərclərinin effektivliyini ölçmək
 Məhsul və kateqoriyalara görə satış trendini təhlil etmək

 Datasetlər
Dataset	Təsviri
Customers_Data.csv	Müştərilərin demoqrafik məlumatları (ID, Gender, Location, Tenure)
Online_Sales.csv	Tranzaksiya məlumatları (Product, Quantity, Price, Delivery, Coupon və s.)
Discount_Coupon.csv	Kupon kodları və endirim faizləri
Marketing_Spend.csv	Offline və online marketinq xərcləri
Tax_Amount.csv	GST faizləri kateqoriyalara görə

 Key Insights
 Satış və Gəlir Analizi
Aylıq və kateqoriyalara görə satış və gəlir izlənildi.
Ən çox gəlir gətirən məhsullar müəyyən edildi.
Endirimlərin gəlirə təsiri təhlil edildi.
Satışların pik həddə çatdığı ay və günlər aşkarlandı.
Metodlar:
Invoice Value hesablaması:
Invoice Value = ((Quantity * Avg_Price) * (1 - Discount_pct)) * (1 + GST) + Delivery_Charges
Average Order Value
Profit Margin
Purchase Frequency

 Müştəri Segmentasiyası (RFM və LTV)
RFM parametrləri:
Recency – son alış tarixi
Frequency – alış sayı
Monetary – xərclənmiş məbləğ

Müştərilər belə qruplaşdırıldı:

Premium
Gold
Silver
Standard

LTV Analizi:
Yüksək LTV → uzunmüddətli dəyərli müştərilər
Orta/Aşağı LTV → hədəf kampaniyalar üçün uyğun müştərilər

Next Purchase Day Analizi
Müştərilərin alış aralığı hesablanaraq qruplaşdırıldı:
0–30 gün                30–60 gün            60+ gün

Marketinq kampaniyalarının düzgün zamanlanması üçün optimallaşdırma imkanı yaradır.

 Cohort Analizi

Müştərilər ilk alış etdikləri aya görə qruplaşdırıldı
Hər cohortun retention faizi izlənildi
Davranış nümunələri və loyallıq səviyyələri təyin edildi
 Market Basket / Cross-Selling Analizi

Birlikdə ən çox alınan məhsullar təyin edildi
Bundle və cross-sell kampaniyaları üçün tövsiyələr formalaşdırıldı
Marketinq & Gəlir Təsiri
Aylıq marketinq xərcləri və gəlir müqayisə edildi
ROI və xərclərin effektivliyi ölçüldü
Online vs Offline marketinqin effektivliyi analiz edildi
 Əsas KPI-lar
Revenue
Average Order Value (AOV)
Profit Margin
Purchase Frequency
Repeat Rate
Churn Rate
Customer Lifetime Value (LTV)

 Business Impact
Marketinq strategiyası RFM və LTV nəticələrinə əsasən formalaşdırıldı
Endirim kampaniyalarının real təsiri ölçüldü
Cohort və Next Purchase Day nəticələri retention-i artırmağa imkan verdi
Cross-selling fürsətləri müəyyən edildi və gəlirin optimallaşdırılması mümkün oldu
