000001210715         DCL-F SHIFTWEEK KEYED USAGE(*INPUT) RENAME(SHIFTWEEK:SHIFTWEEKR);
000002210715         DCL-F SHIFTRATES DISK USAGE(*INPUT) RENAME(SHIFTRATES:SHIFTRATER);
000003210715
000004210715
000005210715         DCL-F PAYRPT2 PRINTER OFLIND(*IN01);
000006210715         DCL-F PAYSUMMAR2 WORKSTN;
000007210715
000008210715         DCL-S HOURSOVER PACKED(3);
000009210715
000010210715         Dcl-PI  Main  ExtPgm('PAYROLLPG2');
000011210715             ShiftType  char(30);
000012210715          End-PI;
000013210715
000014210715
000015210715                        READ SHIFTRATES;
000016210715                        WRITE TITLE;
000017210715                        WRITE COLHDG;
000018210715                        READ SHIFTWEEK;
000019210715
000020210715                        DOW NOT %EOF(SHIFTWEEK);
000021210715                        EXSR PAYSR;
000022210715                        IF *IN01;
000023210715                        WRITE TITLE;
000024210715                        WRITE COLHDG;
000025210715                        *IN01 = *OFF;
000026210715                        ENDIF;
000027210715                        WRITE EMPDETAIL;
000028210715                        READ SHIFTWEEK;
000029210715                        ENDDO;
000030210715
000031210715                        TOTWKPAY = TOTREGPAY + TOTOVTPAY;
000032210715                        WRITE TOTAL;
000033210715                        EXFMT RECORD1;
000034210715                        *INLR = *ON;
000035210715                        RETURN;
000036210715
000037210715       BEGSR PAYSR;
000038210715                        SELECT;
000039210715                        WHEN WORKSHIFT = '1';
000040210715                          HOURLYRATE = DAYHRS;
000041210715                        WHEN WORKSHIFT = '2';
000042210715                          HOURLYRATE = AFTHRS;
000043210715                        WHEN WORKSHIFT = '3';
000044210715                          HOURLYRATE = NIGHTHRS;
000045210715                        ENDSL;
000046210715
000047210715                         SELECT;
000048210715                        WHEN PAYCLASS =  1 ;
000049210715                          EVAL(H) HOURLYRATE = HOURLYRATE * 1.094;
000050210715                        WHEN PAYCLASS =  2 ;
000051210715                          EVAL(H) HOURLYRATE = HOURLYRATE * 1.062;
000052210715                        WHEN PAYCLASS =  3 ;
000053210715                          EVAL(H) HOURLYRATE = HOURLYRATE * 0.957;
000054210715                        ENDSL;
000055210715
000056210715                        HOURSOVER = HRSWORKED - 40;
000057210715
000058210715                        SELECT;
000059210715                               WHEN (HOURSOVER > 0);
000060210715                                  EVAL REGULARPAY = 40 * HOURLYRATE;
000061210715                               EVAL(H) OVERPAY = HOURSOVER * HOURLYRATE * 1.5;
000062210715                                  WEEKLYPAY = REGULARPAY + OVERPAY;
000063210715                                  TOTOVTPAY = TOTOVTPAY + OVERPAY;
000064210715                               OTHER;
000065210715                                 REGULARPAY = HRSWORKED * HOURLYRATE;
000066210715                                 WEEKLYPAY = REGULARPAY;
000067210715                             ENDSL;
000068210715                             //4. Accumulate totals; totregpay, totovtpay
000069210715                             TOTREGPAY = TOTREGPAY + REGULARPAY;
000070210715                             //TOTOVTPAY = TOTOVTPAY + OVERPAY;
000071210715                             TOTWKPAY = REGULARPAY + OVERPAY;
000072210715       ENDSR;
