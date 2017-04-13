/*
MIT License

Copyright (c) 2017 Aurélien Michon aka. orelmi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

class Stream
{
  dyn_anytype array;
  
  public Stream(dyn_anytype array)
  {
    this.array = array;
  }
  
  /** 
    @param predicat 
    @return 
  */
  public Stream filter(function_ptr predicat)
  {
    dyn_anytype out;
    for (int i = 1; i <= dynlen(this.array); i++)
    {
      if (callFunction(predicat, this.array[i]))
      {
        dynAppend(out, array[i]);
      }
    }
    Stream res = Stream(out);
    return res;
  }
  /** 
    @param mapper 
    @return 
  */
  public Stream map(function_ptr mapper)
  {
    dyn_anytype out;
    for (int i = 1; i <= dynlen(this.array); i++)
    {
      anytype obj = callFunction(mapper, this.array[i]);
      dynAppend(out, obj);
    }
    Stream res = Stream(out);
    return res;
  }
  public anytype reduce(function_ptr reducer)
  {
    if (dynlen(this.array) < 2)
    {
      return "";
    }
    anytype obj = callFunction(reducer, this.array[1], this.array[2]);
    for (int i = 3; i <= dynlen(this.array); i++)
    {
      obj = callFunction(reducer, obj, this.array[i]);
    }
    return obj;
  }
  
  public mapping groupBy(function_ptr keySelector)
  {
    mapping out;
    for (int i = 1; i <= dynlen(this.array); i++)
    {
      anytype key = callFunction(keySelector, this.array[i]);
      anytype value = this.array[i];
      if (!mappingHasKey(out, key))
      {
        out[key] = makeDynAnytype();
      }
      dynAppend(out[key], value);
    }
    return out;
  }
  
  public dyn_anytype toArray()
  {
    return this.array;
  }
};

class IntStream
{
  dyn_int array;
  
  public IntStream(dyn_int array)
  {
    this.array = array;
  }
    
  static public int mapper(anytype obj)
  {
    return (int) obj;
  }
  
  public int sum()
  {
    return dynSum(this.array);
  }
  
  public dyn_int toArray()
  {
    return this.array;
  }
};


class LongStream
{
  dyn_long array;
  
  public LongStream(dyn_long array)
  {
    this.array = array;
  }
    
  static public long mapper(anytype obj)
  {
    return (long) obj;
  }
  
  public long sum()
  {
    return dynSum(this.array);
  }
  
  public dyn_long toArray()
  {
    return this.array;
  }
};
 
class FloatStream
{
  dyn_float array;
  
  public FloatStream(dyn_float array)
  {
    this.array = array;
  }
  
  static public float mapper(anytype obj)
  {
    return (float) obj;
  }
    
  public float sum()
  {
    return dynSum(this.array);
  }
  
  public dyn_float toArray()
  {
    return this.array;
  }
};

class StreamBuilder
{
  public Stream buildStream(dyn_anytype& array)
  {
    Stream s = Stream(array);
    return s;
  }
  public IntStream mapToInt(Stream& src)
  {
    Stream stream = src.map(IntStream::mapper);
    IntStream s = IntStream((dyn_int)stream.toArray());
    return s;
  }
  public LongStream mapToLong(Stream& src)
  {
    Stream stream = src.map(LongStream::mapper);
    LongStream s = LongStream((dyn_long)stream.toArray());
    return s;
  }
  public FloatStream mapToFloat(dyn_float& array)
  {
    Stream stream = src.map(FloatStream::mapper);
    FloatStream s = FloatStream((dyn_float)stream.toArray());
    return s;
  }
};

