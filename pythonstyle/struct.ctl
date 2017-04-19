/*
MIT License

Copyright (c) 2017 Aurélien Michon aka orelmi

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

int calcsize(string format)
{
  int s = 0;
  for (int i = 0 ; i < strlen(format); i++)
  {
    char fmt = format[i];
    if (fmt == '<')
    {
      continue;
    }
    if (fmt == '>')
    {
      continue;
    }
    
    if (fmt == 'c' || fmt == 'b')
    {
      s += 1;
    }
    else if (fmt == 'B')
    {
      DebugTN(fmt, "not supported");   
    }
    else if (fmt == '?')
    {
      s += 1;
    }
    else if (fmt == 'h')
    {
      s += 2;
    }
    else if (fmt == 'H')
    {
      DebugTN(fmt, "not supported");      
    }
    else if (fmt == 'i')
    {
      s += 4;
    }
    else if (fmt == 'I')
    {
      s += 4;
    }
    else if (fmt == 'l')
    {
      s += 8;
    }
    else if (fmt == 'L')
    {
      s += 8;
    }
    else
    {
      DebugTN("calcsize, format char", fmt, "not supported");
    }
  }
  return s;
}

dyn_anytype unpack(string format, blob source)
{
  bool bigendian = false;
  dyn_anytype res;
    
  if (calcsize(format) > bloblen(source))
  {
    DebugTN("format is too long");
    return res;
  }  
  if (calcsize(format) < bloblen(source))
  {
    DebugTN("format is too short");
    return res;
  }  
  
  int offset = 0;
  for (int i = 0 ; i < strlen(format); i++)
  {
    char fmt = format[i];
    
    if (fmt == '<')
    {
      bigendian = false;
      continue;
    }
    if (fmt == '>')
    {
      bigendian = true;
      continue;
    }
    
    if (fmt == 'c' || fmt == 'b')
    {
      char value;
      blobGetValue(source, offset, value, 1, bigendian);
      dynAppend(res, value);
      offset+=1;
    }
    else if (fmt == 'B')
    {
      DebugTN(fmt, "not supported");   
    }
    else if (fmt == '?')
    {
      bool value;
      blobGetValue(source, offset, value, 1, bigendian);
      dynAppend(res, value);
      offset+=1;
    }
    else if (fmt == 'h')
    {
      short value;
      blobGetValue(source, offset, value, 2, bigendian);
      dynAppend(res, value);
      offset+=2;
    }
    else if (fmt == 'H')
    {
      DebugTN(fmt, "not supported");      
    }
    else if (fmt == 'i')
    {
      int value;
      blobGetValue(source, offset, value, 4, bigendian);
      dynAppend(res, value);
      offset+=4;
    }
    else if (fmt == 'I')
    {
      uint value;
      blobGetValue(source, offset, value, 4, bigendian);
      dynAppend(res, value);
      offset+=4;
    }
    else if (fmt == 'l')
    {
      long value;
      blobGetValue(source, offset, value, 8, bigendian);
      dynAppend(res, value);
      offset+=8; 
    }
    else if (fmt == 'L')
    {
      ulong value;
      blobGetValue(source, offset, value, 8, bigendian);
      dynAppend(res, value);
      offset+=8; 
    }
    else
    {
      DebugTN("unpack, format char", fmt, "not supported");
    }
  }
  return res;
}

blob pack_args(string format, va_list va_args)
{
  dyn_anytype args;
  int argsLen = va_start(va_args);
  for (int i = 1; i <= argsLen; i++)
  {
    dynAppend(args, va_args[i]);
  }
  return pack(format, args);
}

blob pack(string format, dyn_anytype args)
{
  bool bigendian = false;
  blob target;
  
  int a = 1;
  for (int i = 0 ; i < strlen(format); i++)
  {
    char fmt = format[i];
    
    if (fmt == '<')
    {
      bigendian = false;
      continue;
    }
    if (fmt == '>')
    {
      bigendian = true;
      continue;
    }
    if (fmt == 'c' || fmt == 'b')
    {
      char value = args[a];
      blobAppendValue(target, value, 1, bigendian);
    }
    else if (fmt == 'B')
    {
      DebugTN(fmt, "not supported");   
    }
    else if (fmt == '?')
    {
      bool value = args[a];
      blobAppendValue(target, value, 1, bigendian);      
    }
    else if (fmt == 'h')
    {
      short value = args[a];
      blobAppendValue(target, value, 2, bigendian);
    }
    else if (fmt == 'H')
    {
      DebugTN(fmt, "not supported");      
    }
    else if (fmt == 'i')
    {
      int value = args[a];
      blobAppendValue(target, value, 4, bigendian);
    }
    else if (fmt == 'I')
    {
      uint value = args[a];
      blobAppendValue(target, value, 4, bigendian);      
    }
    else if (fmt == 'l')
    {
      long value = args[a];
      blobAppendValue(target, value, 8, bigendian);
    }
    else if (fmt == 'L')
    {
      ulong value = args[a];
      blobAppendValue(target, value, 8, bigendian);      
    }
    else
    {
      DebugTN("pack, format char", fmt, "not supported");
    }
    a++;
  }
  return target;
}