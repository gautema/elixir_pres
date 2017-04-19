<!-- slide -->
# ![Elixir](logo.png)
### Gaute Magnussen
### gaute.magnussen@webstep.no

<!-- slide -->
# ![Erlang](erlang.png)
  fault tolerant, concurrent, distributed
<!-- slide -->
# ![Erlang](erlang.png)
- Erlang - funksjonelt språk
- OTP - Sett med biblioteker og design patterns
- BEAM - Erlang Virtual Machine
<!-- slide -->
# ![Erlang](erlang.png)
  lightweight processes. med egen heap, stack, gc, mailbox. ikke os-thread. ca 5kb overhead.
  soft realtime
<!-- slide -->
# ![Erlang](erlang.png)
  - laget av Ericsson i 1986
  - Kjører på halvparten av alle mobilswitcher i verden.
<!-- slide -->
# ![Erlang](erlang.png)
  brukes av facebook, amazon, heroku, riak, whatsapp
  whatsapp har 2 millioner devices koblet til hver server

<!-- slide -->
# ![Elixir](logo.png)
  - enkel syntax. lett å lære func programming
  - tre mål med elixir: compability, productivity, extensibility
   http://elixir-lang.org/blog/2013/08/08/elixir-design-goals/

<!-- slide -->
# ![Elixir](logo.png)
> programmers not onboard with functional programming in 5 years will be maintenance programmers

Dave Thomas, GOTO 2014

<!-- slide -->
# Datatyper
```elixir
123 # integer
0x1F # integer
12.34 # float
"Hello world" # string
:hello # atom
[1,2,"hello"] # list
{:ok, 3} # tuple
%{name: "Gaute", age: 35}
%Person{name: "Gaute", age: 35}
fn(x) -> x * x end # function
```


<!-- slide -->
# Syntaks
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
# Immutable
  ```elixir
  iex(2)> x = [1,2,3]
  [1, 2, 3]
  iex(3)> List.delete x, 1
  [2, 3]
  iex(4)> x
  [1, 2, 3]
  ```

<!-- slide -->
# Arrow
  ```elixir
    1..110
    |> Enum.map(&(&1 * &1))
    |> Enum.sort
    |> Enum.sum
  ```

<!-- slide -->
# Pattern matching

<!-- slide -->
# Processes
### Not os-thread
```elixir
  spawn fn ->
    IO.puts("Hello from new process")
  end
```

<!-- slide -->
# Processes
### lightweight
```elixir
    for _ <- 1..100_000 do
      spawn(fn -> :ok end)
    end
```
<!-- slide -->
# Processes
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
# Actors
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
# Agent and GenServer
  - genserver demo

<!-- slide -->
# Macros

<!-- slide -->
# OTP
  - patterns på topp av erlang.

<!-- slide -->
# Hot reload in agent
 - https://github.com/conradwt/blabber-using-elixir/blob/master/README.md

 <!-- slide -->
 # Phoenix og Ecto
   - web development
   - orm med linq support
