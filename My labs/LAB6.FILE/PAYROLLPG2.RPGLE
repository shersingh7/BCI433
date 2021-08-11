000001210702         DCL-F SHIFTWEEK KEYED USAGE(*INPUT) RENAME(SHIFTWEEK:SHIFTWEEKR);
000002210702         DCL-F SHIFTRATES DISK USAGE(*INPUT) RENAME(SHIFTRATES:SHIFTRATER);
000003210702
000004210702
000005210714         DCL-F PAYRPT2 PRINTER OFLIND(*IN01);
000006210714         DCL-F PAYSUMMAR2 WORKSTN;
000007210702
000008210702         DCL-S HOURSOVER PACKED(3);
000009210714
000010210714         Dcl-PI  Main  ExtPgm('PAYROLLPG2');
000011210714             ShiftType  char(30);
000012210714          End-PI;
000013210714
000014210702
000015210702                        READ SHIFTRATES;
000016210702                        WRITE TITLE;
000017210702                        WRITE COLHDG;
000018210702                        READ SHIFTWEEK;
000019210702
000020210702                        DOW NOT %EOF(SHIFTWEEK);
000021210702                        EXSR PAYSR;
000022210702                        IF *IN01;
000023210702                        WRITE TITLE;
000024210702                        WRITE COLHDG;
000025210702                        *IN01 = *OFF;
000026210702                        ENDIF;
000027210702                        WRITE EMPDETAIL;
000028210702                        READ SHIFTWEEK;
000029210702                        ENDDO;
000030210702
000031210702                        TOTWKPAY = TOTREGPAY + TOTOVTPAY;
000032210702                        WRITE TOTAL;
000033210702                        EXFMT RECORD1;
000034210702                        *INLR = *ON;
000035210702                        RETURN;
000036210702
000037210702       BEGSR PAYSR;
000038210702                        SELECT;
000039210702                        WHEN WORKSHIFT = '1';
000040210702                          HOURLYRATE = DAYHRS;
000041210702                        WHEN WORKSHIFT = '2';
000042210702                          HOURLYRATE = AFTHRS;
000043210702                        WHEN WORKSHIFT = '3';
000044210702                          HOURLYRATE = NIGHTHRS;
000047210702                        ENDSL;
000048210702
000049210715                         SELECT;
000050210715                        WHEN PAYCLASS =  1 ;
000051210715                          EVAL(H) HOURLYRATE = HOURLYRATE * 1.094;
000052210715                        WHEN PAYCLASS =  2 ;
000053210715                          EVAL(H) HOURLYRATE = HOURLYRATE * 1.062;
000054210715                        WHEN PAYCLASS =  3 ;
000055210715                          EVAL(H) HOURLYRATE = HOURLYRATE * 0.957;
000056210715                        ENDSL;
000057210702
000058210702                        HOURSOVER = HRSWORKED - 40;
000059210702
000060210715                        SELECT;
000061210715                               WHEN (HOURSOVER > 0);
000062210715                                  EVAL REGULARPAY = 40 * HOURLYRATE;
000063210715                               EVAL(H) OVERPAY = HOURSOVER * HOURLYRATE * 1.5;
000064210715                                  WEEKLYPAY = REGULARPAY + OVERPAY;
000065210715                                  TOTOVTPAY = TOTOVTPAY + OVERPAY;
000066210715                               OTHER;
000067210715                                 REGULARPAY = HRSWORKED * HOURLYRATE;
000068210715                                 WEEKLYPAY = REGULARPAY;
000069210715                             ENDSL;
000070210715                             //4. Accumulate totals; totregpay, totovtpay
000071210715                             TOTREGPAY = TOTREGPAY + REGULARPAY;
000072210715                             //TOTOVTPAY = TOTOVTPAY + OVERPAY;
000073210715                             TOTWKPAY = REGULARPAY + OVERPAY;
000074210702       ENDSR;
