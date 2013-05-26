reset;
# PLIK MODELU
# Deklaracje zbiorów i parametrow zadania

set TOWARY;
set MASZYNY;

# -- PARAMETRY --
# Liczba stanow zmiennej losowej
param stan;

# Zuzycie czasu pracy maszyn 
param zuzycie {m in MASZYNY, t in TOWARY};

# Koszt godziny pracy maszyny w zaleznosci od stanu zmiennej losowej
param koszt_stanu{1..stan, m in MASZYNY};

# Prawdopodobieństwo wystąpienia stanu
param prawd_stanu{1..stan};

# Minimalna produkcja towaru
param min_produkcja{t in TOWARY};

# Maksymalny czas dzierżawy 
param max_czas;

# Czas dodatkowej dzierzawy
param czas_dod;

# Koszt dodatkowej dzierzawy 
param koszt_dod;


# -- ZMIENNE --
# Koszt produkcji w zaleznosci od stanu zmiennej losowej
var koszt{1..stan};

# Produkcja towaru na maszynie
var produkcja {t in TOWARY, m in MASZYNY} integer >= 0;

# Wartosc binarna wydzierzawienia czasu dodatkowego na maszne
var czas_dod_bin {m in MASZYNY} binary := 0;

var ryzyko;

var koszt_sredni;

# Ochylenie przecietne jako miara ryzyka
minimize ryzyko_koszty: ryzyko;

# Dolne ograniczenie ilości wyprodukowanych towarów
subject to produkcja_ogr {t in TOWARY}: sum{m in MASZYNY} produkcja[t,m] >= min_produkcja[t];

subject to koszt_od_stanu_ogr {s in 1..stan}: (sum{m in MASZYNY, t in TOWARY} produkcja[t,m]*zuzycie[m,t]*koszt_stanu[s,m]) = koszt[s];
#+ czas_dod_bin[m]*koszt_dod) = koszt[s];

# produkcja podstawowa
#subject to koszt_od_stanu_ogr {s in 1..stan}: sum{m in MASZYNY, t in TOWARY} produkcja[t,m]*zuzycie[m,t]*koszt_stanu[s,m] <= koszt[s]; 


#subject to koszt_dod_ogr1 {m in MASZYNY}: sum{t in TOWARY} produkcja[t,m]*zuzycie[m,t]-max_czas*koszt_dod = koszt_dod_m[m];
#subject to koszt_dod_ogr2 {m in MASZYNY}: sum{t in TOWARY} prodykcja[t,m]*zuzycie[m,t] <= max_czas + (czas_dod +0.001)*(1-czas_dod_amt[m]);

subject to koszt_sredni_ogr: (sum{s in 1..stan} koszt[s])/stan = koszt_sredni;

subject to wartosc_ryzyka_ogr: (sum{s in 1..stan} abs(koszt[s]-koszt_sredni))/stan = ryzyko;

subject to czas_pracy_ogr {m in MASZYNY}: sum{t in TOWARY} (produkcja[t,m]*zuzycie[m,t]) <= max_czas;
 
#subject to c1 {m in MASZYNY}: (if (sum{t in TOWARY} (produkcja[t,m]*zuzycie[m,t]) <= max_czas) then 1 else 0) = czas_dod_bin[m];

subject to c1 {m in MASZYNY}: (if (sum{t in TOWARY} (produkcja[t,m]*zuzycie[m,t]) <= max_czas) then 1 else 0) = czas_dod_bin[m];


#editme
data dane.dat;

solve;

display _varname, _var;
