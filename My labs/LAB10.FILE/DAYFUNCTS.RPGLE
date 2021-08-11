000000210811
000000210811
000000210811        Ctl-Opt NoMain  ; // no need for *INLR = *ON
000000210811
000000210811      // COPY THE PROTOTYPE HERE
000000210811      /COPY LAB10,DAYPROTO
000000210811       Dcl-Proc DayNumName  EXPORT; // the definition for the user defined function
000000210811                                    // EXPORT -> external linkage
000000210811         Dcl-Pi *N CHAR(9) ;  // char(9) -> what's returned
000000210811           Number  Packed(1); // what is to be recieved
000000210811         End-PI;
000000210811
000000210811          DCL-s DayName Char(9); // local variable
000000210811
000000210811                 SELECT;
000000210811                     WHEN NUMBER = 1;
000000210811                     DAYNAME = 'Monday';
000000210811                     WHEN NUMBER = 2;
000000210811                     DAYNAME = 'Tuesday';
000000210811                     WHEN NUMBER = 3;
000000210811                     DAYNAME = 'Wednesday';
000000210811                     WHEN NUMBER = 4;
000000210811                     DAYNAME = 'Thursday';
000000210811                     WHEN NUMBER = 5;
000000210811                     DAYNAME = 'FRIDAY';
000000210811                     WHEN NUMBER = 6;
000000210811                     DAYNAME = 'Saturday';
000000210811                     WHEN NUMBER = 7;
000000210811                     DAYNAME = 'Sunday';
000000210811                     OTHER;
000000210811                     DAYNAME = 'Unknown';
000000210811                 ENDSL;
000000210811
000000210811                 Return Dayname;
000000210811        End-Proc;
