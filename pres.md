<!-- slide -->
# ![Elixir](logo.png)
### Gaute Magnussen
### gaute.magnussen@webstep.no
<!-- slide -->
# ![Elixir](logo.png)
  > Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang and shares the same abstractions for building distributed, fault-tolerant applications. Elixir also provides a productive tooling and an extensible design. The latter is supported by compile-time metaprogramming with macros and polymorphism via protocols.
<!-- slide -->
# ![Erlang](erlang.png)
> Erlang (/ˈɜːrlæŋ/ er-lang) is a general-purpose, concurrent, functional programming language, as well as a garbage-collected runtime system.

>The term Erlang is used interchangeably with Erlang/OTP, or OTP, which consists of the Erlang runtime system, a number of ready-to-use components mainly written in Erlang, and a set of design principles for Erlang programs.
<!-- slide -->
# ![Erlang](erlang.png)
- Erlang - Språk
- OTP - Sett med biblioteker og design patterns
- BEAM - Erlang Virtual Machine
<!-- slide -->
# ![Erlang](erlang.png)
  - Laget av Ericsson i 1986, open source 1998
  - Kjører på halvparten av alle mobilswitcher i verden.
  - Brukes av Facebook, Amazon, Heroku, Riak, Whatsapp
  - Whatsapp har 2 millioner devices koblet til hver server

<!-- slide -->
# ![Erlang](erlang.png)
\+
  Ekstremt stabilt
  Skalerer godt horisontalt
  Tåler en stor mengde long running connections
  Soft realtime
\-
 Merkelig syntaks
 Mye boilerplatekode
 Mangler muligheter fra moderne språk

<!-- slide -->
# ![Elixir](logo.png)
  - Tre mål med elixir: compability, productivity, extensibility
   http://elixir-lang.org/blog/2013/08/08/elixir-design-goals/

<!-- slide -->
# ![Elixir](logo.png)
> programmers not onboard with functional programming in 5 years will be maintenance programmers

Dave Thomas, GOTO 2014

<!-- slide -->
# ![Elixir](elixir.png) Datatyper
```elixir
123 # integer
0x1F # integer
12.34 # float
"Hello world" # string
:hello # atom
[1,2,"hello"] # list
{:ok, 3, "hei"} # tuple
%{name: "Gaute", age: 35} # map
%Person{name: "Gaute", age: 35} # struct
fn(x) -> x * x end # function
```


<!-- slide -->
#  ![Elixir](elixir.png) Syntaks
```elixir
defmodule Hello do
  def world do
    IO.puts("Hello world!")
  end

  defp priv do
    IO.puts "Can't reach this"
  end
end

Hello.world # prints "Hello world"
Hello.priv() #** (UndefinedFunctionError) function Hello.priv/0 is undefined or private
```

<!-- slide -->
#  ![Elixir](elixir.png) Immutable
  ```elixir
  iex(2)> x = [1,2,3]
  [1, 2, 3]
  iex(3)> List.delete x, 1
  [2, 3]
  iex(4)> x
  [1, 2, 3]
  ```

<!-- slide -->
#  ![Elixir](elixir.png) Arrow
  ```elixir
    1..110
    |> Enum.map(&(&1 * &1))
    |> Enum.sort
    |> Enum.sum
  ```

<!-- slide -->
#  ![Elixir](elixir.png) Pattern matching
```elixir
 x = 1
 1 = 1
 2 = 1 # ** (MatchError) no match of right hand side value: 1
 [x,y] = [1, 2]
 [head | tail] = [1,2,3,4,5]
 {a, b, c} = {:hello, "world", 42}

 {:ok, result} = {:ok, 13}
```

<!-- slide -->
#  ![Elixir](elixir.png) Pattern matching
```elixir
 defmodule Fibonacci do
   def fib(0), do: 0
   def fib(1), do: 1
   def fib(n), do: fib(n-1) + fib(n-2)
 end

```
<!-- slide -->
#  ![Elixir](elixir.png) Processes
### Not os-thread
```elixir
  spawn fn ->
    IO.puts("Hello from new process")
  end
```

<!-- slide -->
#  ![Elixir](elixir.png) Processes
### lightweight
```elixir
    for _ <- 1..100_000 do
      spawn(fn -> :ok end)
    end
```
<!-- slide -->
#  ![Elixir](elixir.png) Processes
### isolation
per process GC, heap, stack
<!-- slide -->
#  ![Elixir](elixir.png) Processes
### message passing
```elixir
 pid = spawn(fn ->
   receive do
     {:msg,contents} -> IO.puts(contents)
   end
 end)

send(pid, "hello")

```

<!-- slide -->
# ![Elixir](elixir.png) Actors
```elixir
  defmodule MyActor do
    def loop(state) do
      receive do
        {from, num} ->
          new_state = state + num
          IO.puts("new state #{new_state}")
          send(from, new_state)
          loop(new_state)
      end
    end
  end

  pid = spawn fn -> MyActor.loop(1) end
  send(pid, {self(), 2})
```

<!-- slide -->
#  ![Elixir](elixir.png) Task
Conveniences for spawning and awaiting tasks.
```elixir
task = Task.async(fn -> do_some_work() end)
res = Task.await(task)
```

<!-- slide -->
# Agent
Simple wrappers around state
```elixir
{:ok, agent} = Agent.start(fn -> 0 end)
# {:ok, #PID<0.70.0>}
Agent.update(agent, &(&1+2))
# :ok
Agent.get(agent, &(&1))
# 2
```

<!-- slide -->
#  ![Elixir](elixir.png) GenServer
```elixir
 genserver.ex
```

<!-- slide -->
#  ![Elixir](elixir.png) Macros
```elixir
2 + 4 # {:+, 1, [2,4]}

defmacro unless(expr, opts) do
  quote do
    if(!unquote(expr), unquote(opts))
  end
end

unless true do
  ...
end
```
<!-- slide -->
# ![Elixir](elixir.png)  Protocols
```elixir
defprotocol JSON do
  def to_json(item)
end

defimpl JSON, for: number do
  ...
end

JSON.to_json(item)

```

<!-- slide -->
#  ![Elixir](elixir.png) Databaser
- ETS
- DETS
- Mnesia

<!-- slide -->
#  ![Elixir](elixir.png) Hot code swap
 ```elixir
 defmodule Blabber do
   def start do
     spawn( __MODULE__, :loop, [1] )
   end

   def loop( count ) do
     receive do
       :done -> IO.puts( "Closing" )
               :ok
     after
       2000 -> IO.puts( "Loop #{node()} with #{count} says hello" )
               Blabber.loop( count + 1 )
     end
   end
 end
 ```
>c("blabber.ex")
>pid = Blabber.start

<!-- slide -->
# ![Elixir](elixir.png)  Interop
```elixir
# Erlang crypto algorithm
:crypto.hash(:sha256, "hash this")
# Shell command
System.cmd("whoami",[])
```
 <!-- slide -->
#  ![Elixir](elixir.png) Tooling
 - Iex
 - Mix
 - Hex
 - ExUnit
 - dialyzer/dialyxir

 <!-- slide -->
 #  ![Elixir](elixir.png) Phoenix og Ecto
   - web-rammeverk
   - orm med linq support

 <!-- slide -->
 # ![Elixir](elixir.png)  Spørsmål?
 ### https://github.com/gautema/elixir_pres
