# Examples without and with pikfit

<style>code { white-space: pre-wrap !important; } </style>

## pikchr

### Using pikchr directly

Original size (Left aligned)

````markdown
```tcl {cmd=pikchr args=[--svg-only] output=html}
scale = 1.2 # scale = 1 seems to be dynamic size
line; box "Hello!"; arrow;
```
````

```tcl {cmd=pikchr args=[--svg-only] output=html hide}
scale = 1.2 # scale = 1 seems to be dynamic size
line; box "Hello!"; arrow;
```

Dynamic size (Full width)

````markdown
```tcl {cmd=pikchr args=[--svg-only] output=html}
line; box "Hello!"; arrow;
```
````

```tcl {cmd=pikchr args=[--svg-only] output=html hide}
line; box "Hello!"; arrow;
```

### Using pikchr through pikfit

Dynamic size (Specified height, Specified alignment)

````markdown
```tcl {cmd=env args=[pikfit -H 3lh -A C] output=html}
line; box "Hello!"; arrow;
```
````

```tcl {cmd=env args=[pikfit -H 3lh -A C] output=html hide}
line; box "Hello!"; arrow;
```

## dpic

### Using dpic directly

Original size (Left aligned)

````markdown
```tcl {cmd=dpic args=[-v] output=html}
.PS
line; box "Hello!"; arrow;
.PE
```
````

```tcl {cmd=dpic args=[-v] output=html hide}
.PS
line; box "Hello!"; arrow;
.PE
```

````markdown
```tcl {cmd=dpic args=[-v] output=html}
.PS 8/2.54 # 8cm
line; box "Hello!"; arrow;
.PE
```
````

```tcl {cmd=dpic args=[-v] output=html hide}
.PS 8/2.54 # 8cm
line; box "Hello!"; arrow;
.PE
```

### Using dpic through pikfit

Original size (Specified alignment)

````markdown
```tcl {cmd=env args=[pikfit --dpic --enclose -A C] output=html}
line; box "Hello!"; arrow;
```
````

```tcl {cmd=env args=[pikfit --dpic --enclose -A C] output=html hide}
line; box "Hello!"; arrow;
```

Dynamic size (Specified width, Specified alignment)

````markdown
```tcl {cmd=env args=[pikfit --dpic --enclose -W 8cm -A C] output=html}
line; box "Hello!"; arrow;
```
````

```tcl {cmd=env args=[pikfit --dpic --enclose -W 8cm -A C] output=html hide}
line; box "Hello!"; arrow;
```

m4 preprocessing

````markdown
```tcl {cmd=env args=[pikfit --dpic --m4 --enclose -W 8cm -A C] output=html}
define(`Hello', ``Hi'')
line; box "Hello!"; arrow;
```
````

```tcl {cmd=env args=[pikfit --dpic --m4 --enclose -W 8cm -A C] output=html hide}
define(`Hello', ``Hi'')
line; box "Hello!"; arrow;
```

## gnuplot

### Using gnuplot directly

Original size (Left aligned)
````markdown
```tcl {cmd=gnuplot output=html}
set term svg size 640, 480 fixed font "Times" fontscale 2
unset key
set tic out nomirror
plot sin(x)
```
````

``` {cmd=gnuplot output=html hide}
set term svg size 600, 480 fixed font "Times" fontscale 2
unset key
set tic out nomirror
plot sin(x)
```

Dynamic size (Full width)

````markdown
```tcl {cmd=gnuplot output=html}
set term svg size 600, 480 dynamic font "Times" fontscale 2
unset key
set tic out nomirror
plot sin(x)
```
````

```tcl {cmd=gnuplot output=html hide}
set term svg size 600, 480 dynamic font "Times" fontscale 2
unset key
set tic out nomirror
plot sin(x)
```

### Using gnuplot through pikfit

Dynamic size (Specified width, Specified alignment)

````markdown
```tcl {cmd=env args=[pikfit --gnuplot --term-opts='font "Times" fontscale 2' -W 75% -A C] output=html}
unset key
set tic out nomirror
plot sin(x)
```
````

```tcl {cmd=env args=[pikfit --gnuplot --term-opts='font "Times" fontscale 2' -W 75% -A C] output=html hide}
unset key
set tic out nomirror
plot sin(x)
```

---
