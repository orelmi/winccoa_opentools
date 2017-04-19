# Overview

WinCC OA Open Tools is a proposal of extensions libraries for WinCC OA Control Script.
You can reuse parts of this software and include them in your WinCC OA Project without fees or royalties.

The project is based on two principles: not reinventing the wheel and reusing concepts that have been proven in other languages and frameworks.
If you want to join the project as contributor, don't hesitate to contact me.

# CTL Libraries

* Streams
* Chrono
* Threading
* Python Style (inspired from Python libraries) : struct

## struct.ctl (pack, unpack)

Functions:
* blob pack(string format, dyn_anytype args)
* blob pack_args(string format, va_list va_args)
* dyn_anytype unpack(string format, blob source)
* int calcsize(string format)

Please, see documentation of pack/unpack from https://docs.python.org/3.7/library/struct.html

Format string specification is not fully implemented (uchar, ushort, float and double are missing)

Usage
```cpp
#uses "struct"
```

This example serialize and deserialize from/to binary data
```cpp
  blob res = pack(">hhl", makeDynAnytype(1, 2, 3));
  DebugTN(bloblen(res), res);
  dyn_anytype st = unpack(">hhl", res);
  DebugTN(st);
```

```
> : pack as big-endian
h : pack as short
l : pack as long
```

The same example with pack_args function, pack_args accept va_list arguments
```cpp
  blob res = pack_args(">hhl", 1, 2, 3);
  DebugTN(bloblen(res), res);
  dyn_anytype st = unpack(">hhl", res);
  DebugTN(st);
```

## streams.ctl (Filter, Map, Reduce, GroupBy)

Usage
```cpp
#uses "streams"
```

We begin to create a collection of data and a stream over collection.
```cpp
dyn_anytype fruits = makeDynString("banana", "orange", "strawberry", "ananas", "peach", "apple");
StreamBuilder b;
Stream src = b.buildStream(fruits);  
```

Here’s an example to convert a stream and return integer values
```cpp
class Mappers
{
  static public int getLength(anytype obj)
  {
    return strlen((string) obj);
  }
};

Stream mapped = src.map(Mappers::getLength);
mapped.toArray()
-------------
[dyn_anytype 6 items
    1: 6
    2: 6
    3: 10
    4: 6
    5: 5
    6: 5
]
```

Here’s an example to filter a stream
```cpp
class Filters
{
  static public bool beginWithA(anytype obj)
  {
    string s = (string) obj;
    return (s[0] == "a");
  }
};

Stream filtered = src.filter(Filters::beginWithA);
filtered.toArray()
-------------
[dyn_anytype 2 items
    1: "ananas"
    2: "apple"
]
```

Here’s an example to reduce a stream
```cpp
class Reducers
{
  static public anytype fruitSalad(anytype x, anytype y)
  {
    return x + y;
  }
};

anytype reduced = src.reduce(Reducers::fruitSalad);
-------------
["bananaorangestrawberryananaspeachapple"]
```

Here's an example to groupby a stream
```cpp
class Entity
{
  string obj;
  int length;
  int id;
  
  public Entity(string obj, int length, int id)
  {
    this.obj = obj;
    this.length = length;
    this.id = id;
  }
  
  static public string keySelector(anytype obj)
  {
    Entity e = obj;
    return e.obj;
  }
};

Entity e1 =  Entity("aaa", 3, 1);
Entity e2 =  Entity("aaa", 3, 2);
Entity e3 =  Entity("bb", 2, 3);

dyn_anytype entities = makeDynAnytype(e1, e2, e3);

StreamBuilder b;
Stream src = b.buildStream(entities);
mapping group = src.groupBy(Entity::keySelector);
-------------
[mapping 2 items
        "aaa" : 	dyn_anytype 2 items
            1: instance 0000018F79F62260 of class Entity
                "obj" : "aaa"
                "length" : 3
                "id" : 1
            2: instance 0000018F79F623A0 of class Entity
                "obj" : "aaa"
                "length" : 3
                "id" : 2
        "bb" : 	dyn_anytype 1 items
            1: instance 0000018F79F62460 of class Entity
                "obj" : "bb"
                "length" : 2
                "id" : 3
]
```

another example with groupBy and a valueSelector
```cpp
class Row
{
  public string dp;
  public time tim;
  public float val;
  
  public Row (dyn_anytype obj)
  {
    this.dp = obj[1];
    this.tim = obj[2];
    this.val = obj[3];
  }
  
  static public anytype valueSelector(anytype obj)
  {
    Row r = Row(obj);
    return r;
  }
  static public anytype keySelector(anytype obj)
  {
    Row r = Row(obj);
    return r.tim;
  } 
};

dyn_dyn_anytype tab;
dpQuery("SELECT '_original.._stime', '_original.._value' FROM '{xxx.yyy.*,xxx.zzz.*}' SORT BY 1 DESC", tab);
StreamBuilder b;
Stream src = b.buildStream(tab);
src.groupBy(Row::keySelector, Row::valueSelector)
```

## chrono.ctl (returns elapsed time in milliseconds)

Usage
```cpp
#uses "chrono"
```

Call Chrono.elapsed() method to meter the time between creation of object and now.
```cpp
Chrono c1;
runTests();
runTests2();
runTests3();
DebugTN(c1.elapsed() + " ms");
```

## threading.ctl (waitUntil)

Usage
```cpp
#uses "threading"
```

Here’s an example using waitUntil to synchronize operations
```cpp

bool state = false;
bool predicat()
{
  return state;
}

void worker(float duration)
{
  state = false;
  delay(duration);
  state = true;
}


startThread("worker", 0.5);
bool res = Threading::waitUntil("predicat", 1., 0.01);
----
res = true
  
startThread("worker", 2);
bool res = Threading::waitUntil("predicat", 1., 0.01);
res = false
```

## TODO & IDEAS

- [X] Core : streams
- [X] Core : chrono
- [X] Core : threading/waituntil
- [ ] Core : Unit Testing Framework
- [ ] Gui : Trend extension
- [ ] Gui : Alarm extension

## License

[MIT](https://github.com/orelmi/winccoa_opentools/blob/master/LICENSE)