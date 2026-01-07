#ifndef TRIGGER_MQH
#define TRIGGER_MQH

bool Trigger_FollowLastCandle()
{
   double body2 = MathAbs(Close[2] - Open[2]);
   double body1 = MathAbs(Close[1] - Open[1]);

   if(Close[1] > Open[1] && body1 > body2)
      trg_isBuy = true;
   else if(Close[1] < Open[1] && body1 > body2)
      trg_isBuy = false;
   else
      return false;

   trg_high = High[1];
   trg_low  = Low[1];
   double range = trg_high - trg_low;

   if(range < MinTriggerRange * Point) return false;
   if(range > MaxTriggerRange * Point) return false;

   double op1_level, op2_level;
   if(trg_isBuy)
   {
      op1_level = trg_high - (EntryPercent/100.0)*range;
      op2_level = trg_high - (OP2Percent/100.0)*range;
   }
   else
   {
      op1_level = trg_low + (EntryPercent/100.0)*range;
      op2_level = trg_low + (OP2Percent/100.0)*range;
   }

   Engine_Setup(trg_isBuy, op1_level);
   trg_OP2_Level = op2_level;
   trg_age       = 0;
   Phase         = PHASE_OP1;

   LogTrigger(op1_level, op2_level);
   SendNotifTrigger(op1_level, op2_level);
   return true;
}

#endif // TRIGGER_MQH
