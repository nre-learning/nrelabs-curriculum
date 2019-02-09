# Introduction to Python
## Part 1 - The Python Interpreter and Basic Data Types

Python is a powerful programming language - combining the simplicity and ease-of-use of a scripting language, with many of the more powerful features
needed to build modern fully-fledged applications. In the world of network automation, it has emerged as the de-facto choice for those that want to be able to perform automated tasks as quickly and simply as possible.

In this lesson, we'll cover the basics of Python, and ensure you have a basic understanding of how to work with it in your journey to Network Reliability Engineering.

You may hear Python referred to as an "interpreted language". Generally, when people use this term, what they mean is that you don't have to "compile" a Python program. By simply executing your code, the Python "interpreter" takes care of performing the necessary steps to translate Python code into lower-level languages that can eventually be understood by the CPU.

This is in contrast to a language like C, where you must first compile your entire program before you can execute it. Because of this, not only can we build Python applications as source code files (ending in `.py`) that we store on the filesystem, like we would with any language, we can also execute Python instructions line-by-line using the interpreter, just like we do with the Bash shell when we execute commands like `echo` or `ls`.

To "enter" the Python interpreter, merely type:

```
python
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 0)">Run this snippet</button>

The prompt has now changed to `>>>` indicating that you're now in the Python interpreter shell. Any commands you type here must be Python-compatible (any of the Bash commands you may have learned in Linux environments, or other lessons, won't work here).

One of the most basic tasks we'll need to be able to do is work with variables in Python. We'll start off by running a command, and then explaining what we just did:

```python
new_var = "Hello, World!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 1)">Run this snippet</button>

We just created a variable. These are placeholders for data that we want to work with in our Python programs. Variables can hold many different kinds of values in Python. We'll briefly explore many of these in this lab. The type we saw in the snippet above is called a **string**". The value we entered can be found inside the double-quotes, and as you can see, this is simply a sequence of characters.

A really handy way to tell the type of a variable is to pass it in to the `type()` function:

```python
type(new_var)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 2)">Run this snippet</button>

We can use the builtin `print()` function to print the contents of any variable back out to our terminal:

```python
print(new_var)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 3)">Run this snippet</button>

Finally, you can add two strings together and form a new string. This is called **concatenation**. There are a variety of ways to do this in Python,
but one of the simplest is shown below simply by using the `+` operator between the two strings:

```python
print(new_var + " This is our new Python program!")
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 4)">Run this snippet</button>

Another type in Python is the `integer`. These can be numbers like 10, 42, or -1:

```python
a = 10
b = 42
c = -1
type(a)
type(b)
type(c)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 5)">Run this snippet</button>

We can also use the `+` sign here, but instead of concatenating the two variables, they're mathematically summed, as one might expect:

```python
print(a + b + c)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 6)">Run this snippet</button>

One of the simplest, but often the most commonly used types is the `boolean` type. These are one of two possible values: `True`, and `False`.

```python
bool_variable = True
type(bool_variable)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 7)">Run this snippet</button>

Note there are no double-quotes here - this is not a string! Both `True` and `False` are special keywords in Python that represent these boolean values. It's also important to note that boolean variables can also be negated, using the `not` keyword:

```python
print(not bool_variable)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 8)">Run this snippet</button>

There are a few other basic types, but that will suffice for now. We should now touch on a few more of the advanced types within Python.

### Advanced Types

Sometimes, the data you want to work with doesn't come in a simple string, or integer. Sometimes it needs more structure to organize the data in the way that makes the most sense.

As with the previous section, we'll only touch on a subset of what's available in Python, but for the purposes of arming you properly for network automation with Python, it's crucial we cover at least two of these advanced data structures. The `list`, and the `dictionary`.

If you have any experience with programming whatsoever, you undoubtedly have encountered the term `array`. This is the most common term for being able to store a sequence of values or variables. In Python, while other similar constructs exist, the commonly used tool for this is called the `list`.

Lists are created using bracket notation, like so:

```python
my_list = [1, 2, 3]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 9)">Run this snippet</button>

Another built-in function we haven't tried yet, `len()` is used to calculate the length of any data type, including lists, that has a length.

```python
len(my_list)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 10)">Run this snippet</button>

Lists in Python are remarkably flexible, especially compared to arrays in other more strongly typed languages. For instance, we can add and remove items from a list very easily:

```python
my_list.append(4)
print(my_list)
my_list.remove(4)
print(my_list)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 11)">Run this snippet</button>

In additon, you don't even have to store items of the same type in a list. The below is totally acceptable!

```python
crazy_list = [123, "hello!", True, -1]
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 12)">Run this snippet</button>

Items within a list can be directly referred to via their index. Lists are zero-indexed, which means that the first item is at
index 0, the second at index 1, and so on.

```python
print(my_list[0])
print(my_list[2])
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 13)">Run this snippet</button>

However, sometimes you need to store bits of data in a sequence, but don't necessarily know or care about the order. This can make it difficult to look up that data later by index, because you won't know what it is. In that case, you may want to consider another advanced data type, Dictionaries. As with Lists, Python uses the term "dictionary" where other languages might use "map", or "hash", but these all mean roughly the same thing. A Dictionary is a way to store key/value pairs. You can think of these almost like little mini-variables within a single data type. For instance, in our first example, we created a string variable. We can create a dictionary to hold this value, and refer to that value using another string:

```python
my_dict = {
  "my_str": "Hello, World!"
}
print(my_dict)
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', 14)">Run this snippet</button>

While it's fun and easy to use the Python interpreter to get familiar with Python commands, the real power is in being able to build repeatable Python code and store it on disk as a program or script. So, for the remainder of this lesson, we'll set aside the interactive interpreter shell, and instead, work through examples embedded in Jupyter notebooks.

See you in the next lab!