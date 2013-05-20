reset;
# PLIK MODELU
# Deklaracje zbiorów i parametrow zadania

set TOWARY;
set MASZYNY;

# Liczba stanow zmiennej losowej
param stan;

# Zuzycie pracy maszyn 
param zuzycie {m in MASZYNY, t in TOWARY};

# Koszt godziny pracy maszyny w zaleznosci od stanu zmiennej losowej
param koszt_stanu{1..stan, m in MASZYNY};

# Prawdopodobieństwo stanu
param prawd_stanu{1..stan};

# Minimalna produkcja towaru
param produkcja{t in TOWARY};

# Maksymalny czas dzierżawy 
param max_czas;

# Czas dodatkowej dzierzawy
param czas_dod;

# Koszt dodatkowej dzierzawy 
param koszt_dod;

# Srednia jako miara kosztu

# Koszt produkcji w zaleznosci od stanu zmiennej losowej
var koszt{1..stan};

# Rozbicie wartosci bezwzglednej na 2 zmienne
var roznica_kosztu_p {1..stan} >= 0;
var roznica_kosztu_m {1..stan} >= 0;

# Produkcja towaru na maszynie
var a {t in TOWARY, m in MASZYNY} integer >= 0;

# Wartosc binarna wydzierzawienia czasu dodatkowego na maszne
var czas_dod_amt {m in MASZYNY} binary;

# Wartość kosztu dodatkowego na maszynie
var koszt_dod_m {m in MASZYNY} >= 0;

var ryzyko;

var koszt_sredni;

# Ochylenie przecietne jako miara ryzyka
minimize ryzyko_koszty: ryzyko;

subject to produkcja_ogr {t in TOWARY}: sum{m in MASZYNY} a[t,m] >= produkcja[t];

subject to koszt_od_stanu_ogr {s in 1..stan}: sum{m in MASZYNY, t in TOWARY} (a[t,m]*zuzycie[m,t]*koszt_stanu[s,m] + koszt_dod_m[m]) = koszt[s];

subject to koszt_dod_ogr1 {m in MASZYNY}: ((sum{t in TOWARY} a[t,m]*zuzycie[m,t])-max_czas)*koszt_dod = koszt_dod_m[m] + 500*czas_dod_amt[m];
subject to koszt_dod_ogr2 {m in MASZYNY}: sum{t in TOWARY} a[t,m]*zuzycie[m,t] <= max_czas + (czas_dod +0.001)*(1-czas_dod_amt[m]);

subject to koszt_sredni_ogr: (sum{s in 1..stan} koszt[s])/stan = koszt_sredni;
subject to rozbicie_abs {s in 1..stan}: roznica_kosztu_p[s]-roznica_kosztu_m[s] = koszt[s]-koszt_sredni;

subject to wartosc_ryzyka_ogr: (sum{s in 1..stan} (roznica_kosztu_p[s]+roznica_kosztu_m[s]))/stan = ryzyko;

subject to czas_pracy_ogr {t in TOWARY}: sum{m in MASZYNY} (a[t,m]*zuzycie[m,t]) <= max_czas+czas_dod;

#editme
data D:\projekty\wdwr13L_kucharczyk_kalamucki\dane.dat;

solve;

display _varname, _var;
