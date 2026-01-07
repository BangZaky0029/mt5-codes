#ifndef ENGINE_MQH
#define ENGINE_MQH

enum TradeState { ENGINE_IDLE, ENGINE_WAIT_EXECUTION, ENGINE_DONE };
TradeState engine_state = ENGINE_IDLE;

bool   engine_isBuy        = false;
double engine_virtualLevel = 0.0;

void Engine_Reset()
{
   engine_state        = ENGINE_IDLE;
   engine_virtualLevel = 0.0;
}

void Engine_Setup(bool isBuy, double level)
{
   engine_isBuy        = isBuy;
   engine_virtualLevel = level;
   engine_state        = ENGINE_WAIT_EXECUTION;
}

void Engine_OnTick()
{
   if(engine_state != ENGINE_WAIT_EXECUTION) return;

   if(engine_isBuy && Ask <= engine_virtualLevel)
   {
      int ticket = OrderSend(Symbol(),OP_BUY,LotSize,Ask,Slippage,0,0,"OP1",0,0,clrBlue);
      if(ticket<0) Print("[Engine] OP1 BUY gagal: ",GetLastError());
      else SendNotifOP1(Ask);   // <<< kirim harga OP1 BUY
      engine_state = ENGINE_DONE;
   }
   else if(!engine_isBuy && Bid >= engine_virtualLevel)
   {
      int ticket = OrderSend(Symbol(),OP_SELL,LotSize,Bid,Slippage,0,0,"OP1",0,0,clrRed);
      if(ticket<0) Print("[Engine] OP1 SELL gagal: ",GetLastError());
      else SendNotifOP1(Bid);   // <<< kirim harga OP1 SELL
      engine_state = ENGINE_DONE;
   }
}

#endif
