CREATE
    ALGORITHM = TEMPTABLE
    DEFINER = `agnmeinardo`@`%`
    SQL SECURITY DEFINER
VIEW `viewContenidoTicket19` AS
    SELECT
        `c`.`idBase` AS `Base`,
        `t`.`idCampania` AS `Campania`,
        `c`.`ANI` AS `ANI`,
        `t`.`Estado` AS `Estado`,
        `t`.`SubEstado` AS `SubEstado`,
        `t`.`THablado` AS `THablado`,
        (SELECT
                COUNT(`v`.`idVenta`)
            FROM
                `Ventas` `v`
            WHERE
                ((`v`.`ANI` = `c`.`ANI`)
                    AND (`v`.`FechaSolicitacion` = `t`.`Fecha`)
                    AND (`v`.`idCampania` = (SELECT
                        `p`.`idCampania`
                    FROM
                        `ParamReportePrueba` `p`)))) AS `Venta`
    FROM
        (`Tickets_2019` `t`
        JOIN `ContenidoBases` `c` ON ((`t`.`ANI` = `c`.`ANI`)))
    WHERE
        ((MONTH(`t`.`Fecha`) = 12)
            AND (`c`.`idBase` = (SELECT
                `p`.`idBase`
            FROM
                `ParamReportePrueba` `p`))
            AND (`t`.`idCampania` = (SELECT
                `p`.`idCampania`
            FROM
                `ParamReportePrueba` `p`)))
