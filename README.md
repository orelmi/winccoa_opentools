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
  
  static public string getIdentity(anytype obj)
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
mapping group = src.groupBy(Entity::getIdentity);
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


## TODO & IDEAS

- [ ] Core : streams (Join, Concat, ...)
- [ ] Core : Unit Testing Framework
- [ ] Gui : Trend extension
- [ ] Gui : Alarm extension

## License

[MIT](https://github.com/orelmi/winccoa_opentools/blob/master/LICENSE)