#ifndef CONFIG_MQH
#define CONFIG_MQH

enum PhaseState { PHASE_IDLE = 0, PHASE_OP1, PHASE_FREEZE };
PhaseState Phase     = PHASE_IDLE;
int        LastPhase = -1;

bool   trg_isBuy      = false;
double trg_high       = 0.0;
double trg_low        = 0.0;
double trg_OP2_Level  = 0.0;
int    trg_age        = 0;

int TotalOpenOrders()
{
   int total=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol()) total++;
   return total;
}

double FloatingProfitUSD()
{
   double p=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
            p += OrderProfit()+OrderSwap()+OrderCommission();
   return p;
}

bool CloseAllOrders()
{
   bool ok=true;
   for(int i=OrdersTotal()-1;i>=0;i--)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
         {
            bool res=false;
            if(OrderType()==OP_BUY)
               res = OrderClose(OrderTicket(),OrderLots(),Bid,Slippage);
            else if(OrderType()==OP_SELL)
               res = OrderClose(OrderTicket(),OrderLots(),Ask,Slippage);
            ok = ok && res;
         }
   return ok;
}

#endif
