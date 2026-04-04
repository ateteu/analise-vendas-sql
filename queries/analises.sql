-- =====================================================
-- ANÁLISE 1: Total de vendas por dia
-- =====================================================

SELECT 
    date, 
    SUM(qty) AS total_vendas_no_dia
FROM vendas
GROUP BY date
ORDER BY date ASC;


-- =====================================================
-- ANÁLISE 2: Valor total vendido por produto
-- =====================================================

SELECT 
    p.produto, 
    ROUND(SUM(v.qty * p.preco)) AS valor_total_vendido
FROM produtos p
JOIN vendas v 
    ON v.codigo = p.codigo
GROUP BY p.produto
ORDER BY valor_total_vendido DESC;


-- =====================================================
-- ANÁLISE 3: Produtos com preço acima da média geral
-- =====================================================

SELECT 
    produto, 
    preco
FROM produtos
WHERE preco >= (
    SELECT AVG(preco) FROM produtos
)
ORDER BY preco DESC;


-- =====================================================
-- ANÁLISE 4: Classificação de produtos por faixa de preço
-- =====================================================

SELECT 
    produto, 
    preco,
    CASE 
        WHEN preco >= 100 THEN 'Caro'
        WHEN preco >= 50 THEN 'Intermediário'
        ELSE 'Barato'
    END AS categoria_preco
FROM produtos
ORDER BY preco ASC;


-- =====================================================
-- ANÁLISE 5: Quantidade de vendas por país e produto
-- =====================================================

SELECT 
    v.ship_country, 
    p.produto, 
    COUNT(*) AS total_vendas
FROM vendas v
JOIN produtos p 
    ON v.codigo = p.codigo
GROUP BY 
    v.ship_country, 
    p.produto
ORDER BY 
    v.ship_country ASC,
    total_vendas DESC;


-- =====================================================
-- ANÁLISE 6: Média de preço por marca (filtrando médias > 50)
-- =====================================================

SELECT
    CASE
        WHEN produto LIKE '%apple%'    THEN 'Apple'
        WHEN produto LIKE '%lego%'     THEN 'LEGO'
        WHEN produto LIKE '%samsung%'  THEN 'Samsung'
        WHEN produto LIKE '%philips%'  THEN 'Philips'
        WHEN produto LIKE '%nintendo%' THEN 'Nintendo'
        WHEN produto LIKE '%hyper x%'  THEN 'HyperX'
        WHEN produto LIKE '%sandisk%'  THEN 'SanDisk'
        ELSE 'Outras'
    END AS marca,
    ROUND(AVG(preco)) AS media_preco
FROM produtos
GROUP BY marca
HAVING AVG(preco) > 50
ORDER BY media_preco ASC;


-- =====================================================
-- ANÁLISE 7: Pedidos com status de envio não informado (NULL)
-- =====================================================

SELECT
    v.ship_country AS pais_destino,
    p.produto,
    COUNT(v.order_id) AS total_pedidos_null
FROM vendas v
JOIN produtos p 
    ON v.codigo = p.codigo
WHERE v.courier_status IS NULL
GROUP BY 
    v.ship_country,
    p.produto
ORDER BY 
    total_pedidos_null DESC;