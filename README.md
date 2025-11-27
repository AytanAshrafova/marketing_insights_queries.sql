# marketing_insights_queries.sql

MARKETING INSIGHTS FOR E-COMMERCE - postgresql queries
Bu skript Marketing Insights for E-Commerce layihəsi üçün istifadə olunan bütün SQL sorğularını ehtiva edir.
Sorğular bir neçə kateqoriyaya bölünmüşdür:
1. Müştəri Analizi
2. Satış Analizi
3. Məhsul və Kateqoriya Analizi
4. Endirim və Marketinq Xərcləri Analizi
5. Əlavə Analitiklər

1. Chicago şəhərində olan müştərilər
   SELECT * FROM public.customerdata
WHERE Location = 'Chicago';
