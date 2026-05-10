USE AdventureWorksDW2022;
GO

SELECT TOP 10 *
FROM FactInternetSales;


SELECT 
    d.CalendarYear AS Anio,
    d.MonthNumberOfYear AS NumeroMes,
    d.EnglishMonthName AS Mes,
    SUM(f.SalesAmount) AS VentasMensuales
FROM FactInternetSales f
INNER JOIN DimDate d
    ON f.OrderDateKey = d.DateKey
GROUP BY 
    d.CalendarYear,
    d.MonthNumberOfYear,
    d.EnglishMonthName
ORDER BY 
    d.CalendarYear,
    d.MonthNumberOfYear;



	WITH VentasCategoria AS (
    SELECT 
        pc.EnglishProductCategoryName AS Categoria,
        SUM(f.SalesAmount) AS TotalIngresos
    FROM FactInternetSales f
    INNER JOIN DimProduct p
        ON f.ProductKey = p.ProductKey
    INNER JOIN DimProductSubcategory ps
        ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
    INNER JOIN DimProductCategory pc
        ON ps.ProductCategoryKey = pc.ProductCategoryKey
    GROUP BY pc.EnglishProductCategoryName
),
Pareto AS (
    SELECT
        Categoria,
        TotalIngresos,
        SUM(TotalIngresos) OVER () AS TotalGeneral,
        SUM(TotalIngresos) OVER (
            ORDER BY TotalIngresos DESC
        ) AS IngresoAcumulado
    FROM VentasCategoria
)
SELECT 
    Categoria,
    TotalIngresos,
    CAST((TotalIngresos / TotalGeneral) * 100 AS DECIMAL(10,2)) AS PorcentajeIngresos,
    CAST((IngresoAcumulado / TotalGeneral) * 100 AS DECIMAL(10,2)) AS PorcentajeAcumulado
FROM Pareto
ORDER BY TotalIngresos DESC;













SELECT 
    st.SalesTerritoryCountry AS Pais,
    st.SalesTerritoryRegion AS Region,
    SUM(f.SalesAmount) AS TotalVentas
FROM FactInternetSales f
INNER JOIN DimSalesTerritory st
    ON f.SalesTerritoryKey = st.SalesTerritoryKey
GROUP BY 
    st.SalesTerritoryCountry,
    st.SalesTerritoryRegion
ORDER BY TotalVentas ASC;