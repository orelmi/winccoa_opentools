class Chrono
{
  time t;
  
  public Chrono()
  {
    this.reset();
  }
  public void reset()
  {
    this.t = getCurrentTime();
  }
  public long elapsed()
  {
    return ((float) (getCurrentTime() - this.t)) * 1000;
  }
};
