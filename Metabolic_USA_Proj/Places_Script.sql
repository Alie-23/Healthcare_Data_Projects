-- Creating table that shows the top 3 US metabolic conditions: obesity, diabetes, 
-- and high blood pressure
CREATE TABLE places_final AS
SELECT
    StateAbbr,
    StateDesc,
    CountyName,
    CountyFIPS,
    TotalPopulation,
    TotalPop18plus,
    MetabolicCondition,
    Prevalence,
    DENSE_RANK() OVER (
        PARTITION BY MetabolicCondition
        ORDER BY Prevalence DESC
    ) AS RankedRisk,
    -- Based on data, highest prevalence is ~47 and lowest is 6
    CASE
        WHEN Prevalence >= 30 THEN 'High Risk'
        WHEN Prevalence >= 20 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS RiskLevel
FROM (
    SELECT
        StateAbbr,
        StateDesc,
        CountyName,
        CountyFIPS,
        TotalPopulation,
        TotalPop18plus,
        'Obesity' AS MetabolicCondition,
        OBESITY_AdjPrev AS Prevalence
    FROM PLACES
    WHERE OBESITY_AdjPrev IS NOT NULL

    UNION ALL

    SELECT
        StateAbbr,
        StateDesc,
        CountyName,
        CountyFIPS,
        TotalPopulation,
        TotalPop18plus,
        'Diabetes' AS MetabolicCondition,
        DIABETES_AdjPrev AS Prevalence
    FROM PLACES
    WHERE DIABETES_AdjPrev IS NOT NULL

    UNION ALL

    SELECT
        StateAbbr,
        StateDesc,
        CountyName,
        CountyFIPS,
        TotalPopulation,
        TotalPop18plus,
        'High Blood Pressure' AS MetabolicCondition,
        BPHIGH_AdjPrev AS Prevalence
    FROM PLACES
    WHERE BPHIGH_AdjPrev IS NOT NULL
) AS process_places
WHERE Prevalence != ''; --removed because of the blanks