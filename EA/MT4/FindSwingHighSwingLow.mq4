//+------------------------------------------------------------------+
//|                                        FindSwingHighSwingLow.mq4 |
//|                                  Copyright 2024, Trader Geny 18. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Trader Geny 18."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// Input parameters for ZigZag indicator
input int ExtDepth     = 12;
input int ExtDeviation = 5;
input int ExtBackstep  = 3;

// Arrays to store swing highs and lows
double SwingHighs[];
double SwingLows[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   ArrayResize(SwingHighs, 0);
   ArrayResize(SwingLows, 0);
   Print("ZigZag Swing High/Low EA initialized.");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   int bars = Bars;
   double zigzagHighBuffer[];
   double zigzagLowBuffer[];

   ArrayResize(zigzagHighBuffer, bars);
   ArrayResize(zigzagLowBuffer, bars);

   ArraySetAsSeries(zigzagHighBuffer, true);
   ArraySetAsSeries(zigzagLowBuffer, true);

   // Read swing highs and lows from ZigZag buffers
   for (int i = 0; i < bars; i++)
   {
      zigzagHighBuffer[i] = iCustom(NULL, 0, "ZigZag", ExtDepth, ExtDeviation, ExtBackstep, 1, i);
      zigzagLowBuffer[i]  = iCustom(NULL, 0, "ZigZag", ExtDepth, ExtDeviation, ExtBackstep, 2, i);
   }

   // Process buffers to extract swing points
   FindSwingHighs(zigzagHighBuffer);
   FindSwingLows(zigzagLowBuffer);

   // Get most recent swing high/low
   double lastSwingHigh = GetLastSwingHigh();
   double lastSwingLow = GetLastSwingLow();

   if (lastSwingHigh != EMPTY_VALUE)
      Print("Last Swing High: ", lastSwingHigh);
   else
      Print("No swing high found.");

   if (lastSwingLow != EMPTY_VALUE)
      Print("Last Swing Low: ", lastSwingLow);
   else
      Print("No swing low found.");
}

//+------------------------------------------------------------------+
//| Store swing highs from ZigZag buffer                            |
//+------------------------------------------------------------------+
void FindSwingHighs(double &buffer[])
{
   ArrayResize(SwingHighs, Bars);
   for (int i = 0; i < Bars; i++)
   {
      if (buffer[i] != 0.0)
         SwingHighs[i] = buffer[i];
      else
         SwingHighs[i] = EMPTY_VALUE;
   }
}

//+------------------------------------------------------------------+
//| Store swing lows from ZigZag buffer                             |
//+------------------------------------------------------------------+
void FindSwingLows(double &buffer[])
{
   ArrayResize(SwingLows, Bars);
   for (int i = 0; i < Bars; i++)
   {
      if (buffer[i] != 0.0)
         SwingLows[i] = buffer[i];
      else
         SwingLows[i] = EMPTY_VALUE;
   }
}

//+------------------------------------------------------------------+
//| Return the last swing high found                                 |
//+------------------------------------------------------------------+
double GetLastSwingHigh()
{
   for (int i = 0; i < Bars; i++)
   {
      if (SwingHighs[i] != EMPTY_VALUE)
         return SwingHighs[i];
   }
   return EMPTY_VALUE;
}

//+------------------------------------------------------------------+
//| Return the last swing low found                                  |
//+------------------------------------------------------------------+
double GetLastSwingLow()
{
   for (int i = 0; i < Bars; i++)
   {
      if (SwingLows[i] != EMPTY_VALUE)
         return SwingLows[i];
   }
   return EMPTY_VALUE;
}
