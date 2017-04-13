#uses "chrono"

class Threading
{
  static public bool waitUntil(string predicat, float timeout, float pollingTime, va_list args)
  {
    Chrono chrono;
    while (true)
    {
        if (callFunction(predicat, args))
        {
            return true;
        }
        int left_time = (int)(timeout*1000 - chrono.elapsed());
        if (left_time <= 0)
        {
            break;
        }
        delay(pollingTime);
    }
    return false;
  }
};
