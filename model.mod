# PLIK MODELU
# Deklaracje zbiorów i parametrow zadania

set TOWARY;
set MASZYNY;

# Liczba stanow zmiennej losowej
param stan;

# Zuzycie pracy maszyn 
param zuzycie {t in TOWARY, m in MASZYNY};

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

# Produkcja towaru na maszynie
var a {t in TOWARY, m in MASZYNY} >= 0;

var ryzyko;

var koszt_sredni;

# Ochylenie przecietne jako miara ryzyka
minimize ryzyko_koszty: ryzyko + koszt	;

subject to ograniczenie_produkcji {t in TOWARY}: sum{m in MASZYNY} a[t,m] >= produkcja[t];

subject to koszt_od_stanu {s in 1..stan}: sum{t in TOWARY, m in MASZYNY} a[t,m]*zuzycie[t,m]*koszt_stanu[s,m] <= koszt[s];

subject to koszt_sredni: (sum{s in 1..stan} koszt[s])/stan <= koszt_sredni;

subject to wartosc_ryzyka: (sum{s in 1..stan} abs(koszt[s]-koszt_sredni))/stan <= ryzyko;
