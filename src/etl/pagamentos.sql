-- Active: 1708342533023@@127.0.0.1@3306
WITH tb_join AS (
    SELECT t2.*, t1."dtPedido", t3."idVendedor"
    FROM pedido as t1
    LEFT JOIN pagamento_pedido as t2
    ON t1."idPedido" = t2."idPedido"
    LEFT JOIN item_pedido as t3
    ON t1."idPedido" = t3."idPedido"
    WHERE t1.dtPedido < '2018-01-01'
    AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
    AND t3."idVendedor" is not NULL
    ORDER BY t1."dtPedido" desc
),
tb_group AS (
    SELECT idVendedor,
        descTipoPagamento,
        count(DISTINCT idPedido) as qtdePedidoMeioPgto,
        sum(vlPagamento) as vlPedidoMeioPgto
    from tb_join
    GROUP BY 1,2
    ORDER BY 1,2
)


SELECT DISTINCT idVendedor ,
    sum(case when descTipoPagamento = 'credit_card' then qtdePedidoMeioPgto else 0 end) as qtde_credit_card_pedido,
    sum(case when descTipoPagamento = 'boleto' then qtdePedidoMeioPgto else 0 end) as qtde_boleto_pedido,
    sum(case when descTipoPagamento = 'debit_card' then qtdePedidoMeioPgto else 0 end) as qtde_debit_card_pedido,
    sum(case when descTipoPagamento = 'voucher'  then qtdePedidoMeioPgto else 0 end) as qtde_voucher_pedido

FROM tb_group
GROUP BY 1;
