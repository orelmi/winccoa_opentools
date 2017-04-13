# Overview

WinCC OA Open Tools is a proposal of extensions libraries for WinCC OA Control Script.
You can reuse parts of this software and include them in your WinCC OA Project without fees or royalties.

The project is based on two principles: not reinventing the wheel and reusing concepts that have been proven in other languages and frameworks.
If you want to join the project as contributor, don't hesitate to contact me.

## streams.ctl (Filter, Map, Reduce)

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


## TODO & IDEAS

- [ ] Core : streams (GroupBy, Join, Concat, ...)
- [ ] Core : Unit Testing Framework
- [ ] Gui : Trend extension
- [ ] Gui : Alarm extension

## License

[MIT](https://github.com/orelmi/winccoa_opentools/blob/master/LICENSE)