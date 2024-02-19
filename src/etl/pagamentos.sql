-- Active: 1708176304050@@127.0.0.1@3306
SELECT DATE(dtPedido) as dtPedido, 
    count(*) as qtdPedido
FROM pedido 
GROUP BY 1
ORDER BY 1;