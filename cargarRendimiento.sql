CREATE DEFINER=`agnmeinardo`@`%` PROCEDURE `cargarRendimiento`()
BEGIN
  DECLARE done INT DEFAULT FALSE;

  DECLARE campania, base, tickets, atendimos, argumentamos, vacias, ventas INT;
  DECLARE cur CURSOR FOR SELECT c.idCampania, b.idBase FROM argentina.Campanias c , argentina.Bases b ;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  load_loop: LOOP
    FETCH cur INTO campania, base;
    IF done THEN
      LEAVE load_loop;
    END IF;

   # Lo hace
   	DELETE FROM argentina.ParamReportePrueba;
	INSERT INTO argentina.ParamReportePrueba (idBase, idCampania) VALUES (base,campania);

	SET tickets = (SELECT IFNULL(COUNT(*),0) FROM argentina.viewContenidoTicket20);
	SET atendimos = (SELECT IFNULL(COUNT(*),0) FROM argentina.viewContenidoTicket20 WHERE Estado = "ANSWER");
	SET argumentamos = (SELECT IFNULL(COUNT(*),0) FROM argentina.viewContenidoTicket20 WHERE SubEstado = "AGENT" AND THablado > 20);
	SET vacias = (SELECT IFNULL(COUNT(*),0) FROM argentina.viewContenidoTicket20 WHERE SubEstado = "AGENT" AND THablado < 8) ;
	SET ventas = (SELECT (IFNULL(COUNT(DISTINCT v.ANI),0)) FROM argentina.viewContenidoTicket20 v WHERE v.Venta > 0);

    UPDATE argentina.RendimientoBasesCampania
    SET HTicketsGenerados = HTicketsGenerados + tickets, vueltas = ((HticketsGenerados)/cantDatosBase ), HAtendimos = HAtendimos + atendimos, HAtendimosPorc = (((HAtendimos + atendimos) / (HticketsGenerados +tickets)) *100) ,HArgumentamos = HArgumentamos + argumentamos ,HArgumentamosPorc = (((HArgumentamos + argumentamos ) / (HticketsGenerados +tickets)) *100), HVacias = HVacias + vacias, HVaciasPorc = (((HVacias + vacias) / (HticketsGenerados +tickets)) *100) , HVentas = HVentas + ventas, HAtVentas = ((HAtendimos + atendimos) / (HVentas + ventas)), HArgVentas = ((HArgumentamos + argumentamos) / (HVentas + ventas))
    WHERE idCampania = campania AND idBase = base;

  END LOOP;

  CLOSE cur;

END
