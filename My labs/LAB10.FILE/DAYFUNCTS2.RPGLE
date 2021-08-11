000000210811
000000210811        // DatFmt used to ensure that *USA is the default for all dates
000000210811        Ctl-Opt NoMain DatFmt(*USA);
000000210811
000000210811      // COPY THE PROTOTYPE HERE
000000210811      /COPY LAB10,DAYPROTO
000000210811       Dcl-Proc DayNumName  EXPORT;
000000210811         Dcl-Pi *N CHAR(9) ;
000000210811           Number  Packed(1);
000000210811         End-PI;
000000210811
000000210811
000000210811         DCL-DS DayData;
000000210811           *n Char(9) Inz('Monday');
000000210811           *n Char(9) Inz('Tuesday');
000000210811           *n Char(9) Inz('Wednesday');
000000210811           *n Char(9) Inz('Thursday');
000000210811           *n Char(9) Inz('Friday');
000000210811           *n Char(9) Inz('Saturday');
000000210811           *n Char(9) Inz('Sunday');
000000210811
000000210811           DayArray Char(9) Dim(7) Pos(1);
000000210811
000000210811         END-DS;
000000210811
000000210811                 Return DayArray(Number);
000000210811        End-Proc;
