# Dominis i Problemes de Planificació en PDDL

PDDL suporta STRIPS, ADL i molt més. No obstant això, la majoria de planners no admeten totes les funcionalitats definides pel PDDL. La majoria només admeten el subconjunt STRIPS o alguna petita extensió d'aquest. A més, molts planners tenen les seves pròpies "excentricitats", el que significa que poden interpretar certs constructes PDDL incorrectament o requerir petites variacions en la sintaxi que no s'alineen amb l'especificació oficial del llenguatge. Alguns exemples:

- Alguns planners tenen una restricció implícita que tots els arguments d'una acció han de ser diferents.
- D'altres requereixen que les precondicions i/o efectes de les accions siguin escrits com a conjuncions, és a dir `(and ...)`, fins i tot quan la precondició/efecte conté només una condició atòmica o cap condició.
- La majoria de planners ignoren la part `:requirements` de la definició del domini. No obstant això, alguns planners poden fallar en analitzar una definició de domini si aquesta part falta o conté una paraula clau no reconeguda.

Una pràctica útil a l'hora d'escriure PDDL és utilitzar un model el més simple possible per expressar el problema. Considera també llegir la documentació del planner que estàs utilitzant per saber quant més enllà d'STRIPS arriben.

## Què necessitem definir per modelar un problema en PDDL:

- **Objectes**: Elements rellevants per al problema en qüestió.
- **Predicats**: Propietats d'aquests objectes i relacions entre ells.
- **Estat inicial**: L'estat del món des del qual comencem.
- **Objectiu**: Allò que volem que sigui cert o fals per considerar el problema resolt.
- **Accions/Operadors**: Maneres de canviar l'estat del món.

### On definim aquests components:

Els problemes en PDDL es separen en dos fitxers:
1. **Fitxer de domini (domain file)** per a predicats i accions.
2. **Fitxer de problema (problem file)** per a objectes, estat inicial i objectiu.

**Nota:** La majoria de planners requereixen que aquestes parts estiguin en fitxers separats, tot i que el PDDL mateix no ho exigeix.

### Comentaris en PDDL

- Els comentaris en un fitxer PDDL comencen amb un punt i coma (`;`) i s'estenen fins al final de la línia.

## Definició de Domini

La definició del domini essencialment conté la declaració dels predicats i la definició del esquemes de les accions (sovint ens hi referim simplement com a accions o com a operadors). També pot incloure declaracions de tipus i la seva jerarquia, constants i fets estàtics, però bastants planners no admeten aquestes característiques.

### **El format de la definició de dominis en PDDL:**

```pddl
(define (domain NOM_DEL_DOMINI)
  (:requirements [:strips] [:equality] [:typing] [:adl])
  (:predicates (NOM_PREDICAT_1 ?A1 ?A2 ... ?AN)
               (NOM_PREDICAT_2 ?A1 ?A2 ... ?AM) ...)

  (:action NOM_ACCIO_1
    [:parameters (?P1 ?P2 ... ?PK)]
    [:precondition FORMULA_PRECOND]
    [:effect FORMULA_EFECTE])

  (:action NOM_ACCIO_2
    [:parameters (?P1 ?P2 ... ?PL)]
    [:precondition FORMULA_PRECOND]
    [:effect FORMULA_EFECTE]))
  ...
)
```

- Els noms (de domini, de predicat, d'acció, etc.) normalment utilitzen caràcters alfanumèrics, guions (`-`) i guions baixos (`_`).
- Els paràmetres de predicats i accions sempre comencen amb `?`. Els paràmetres de predicats especifiquen el nombre d'arguments però no afecten la lògica.

## Declaració de Requisits

Com que PDDL és un llenguatge molt general i la majoria de planners només n'admeten un subconjunt, els dominis poden declarar requisits. Els requisits comuns inclouen:

- `:strips` → Subconjunt bàsic STRIPS.
- `:equality` → Utilitza el predicat `=` per a la igualtat entre objectes (assumint que si dos objectes tenen nom diferent és que són diferents).
- `:typing` → Utilitza declaracions de tipus i permet declarar jerarquies de subtipatge entre ells.
- `:adl` → Utilitza característiques ADL (per exemple, disjuncions, quantificadors i efectes condicionals).

## Què Signifiquen els Predicats?

Una cosa important d'entendre és que, a part del predicat especial `=`, els predicats en una definició de domini no tenen un significat intrínsec. La part `(:predicates ...)` d'una definició de domini especifica només quins són els noms de predicats utilitzats en el domini, i el seu nombre d'arguments (i tipus d'arguments, si el domini utilitza tipus). El "significat" d'un predicat, en el sentit de per a quines combinacions d'arguments pot ser cert i la seva relació amb altres predicats, està determinat pels efectes que les accions en el domini poden tenir sobre el predicat, i per quines instàncies del predicat es llisten com a certes en l'estat inicial de la definició del problema.

És comú fer la distinció entre **predicats estàtics** i **dinàmics**: un predicat estàtic no pot ser canviat per cap acció. Així, en un problema, les úniques instàncies d'un predicat estàtic que seran sempre certes, dit d'una altra maner, el únics àtoms que tenen aquell predicat que seran sempre certs, seran precisament els àtoms llistats en l'especificació de l'estat inicial de la definició del problema. Fixeu-vos que no hi ha cap diferència sintàctica entre predicats estàtics i dinàmics en PDDL: són exactament iguals en la part de declaració (`:predicates`) del domini. No obstant això, alguns planners poden admetre construccions diferents al voltant de predicats estàtics i dinàmics, per exemple, permetent que els àtoms de predicats estàtics siguin negats en les precondicions d'accions però no els dinàmics.

## Definicions d'Accions

Les definicions d'accions consten de:
- **Nom de l'Acció**
- **Paràmetres** (opcional)
- **Precondicions** (opcional)
- **Efectes** (opcional, però essencial per a que la acció tingui sentit)

### Fórmules de Precondició

En un domini STRIPS, una fórmula de precondició pot ser:
* Una fórmula atòmica: `(NOM_DEL_PREDICAT ARG1 ... ARG_N)` Els arguments del predicat han de ser paràmetres de l'acció (o constants declarades en el domini, si el domini té constants).
* Una conjunció de fórmules atòmiques: `(and ATOM1 ... ATOM_N)`

Si el domini utilitza `:equality`, una fórmula atòmica també pot ser de la forma `(= ARG1 ARG2)`. Molts planners que admeten la igualtat també permeten la igualtat negada, que s'escriu `(not (= ARG1 ARG2))`, fins i tot si no permeten la negació en cap altra part de la definició.

En un domini ADL, una fórmula de precondició pot ser, a més:
* Una negació, conjunció o disjunció general: 
  * `(not FORMULA_CONDICIO)`
  * `(and FORMULA_CONDICIO1 ... FORMULA_CONDICIO_N)`
  * `(or FORMULA_CONDICIO1 ... FORMULA_CONDICIO_M)`
* Una fórmula quantificada:
  * `(forall (?V1 ?V2 ...) FORMULA_CONDICIO)`
  * `(exists (?V1 ?V2 ...) FORMULA_CONDICIO)`

Fixeu-vos que un quantificador pot quantificar més d'una variable. Hi ha planner que demanen que les variables quantificades tinguin tipus, per exemple: `(forall (?x - object) ...)`

### Fórmules d'Efecte

En PDDL, els efectes d'una acció no es divideixen explícitament en "adds" i "deletes". En canvi, els efectes negatius (deletes) es denoten mitjançant la negació, és a dir `(not ...)`

En un domini STRIPS, una fórmula d'efecte pot consistir en:
* Un àtom afegit: `(NOM_DEL_PREDICAT ARG1 ... ARG_N)`. Els arguments del predicat han de ser paràmetres de l'acció (o constants declarades en el domini, si el domini té constants).
* Un àtom eliminat: `(not (NOM_DEL_PREDICAT ARG1 ... ARG_M))`
* Una conjunció d'efectes atòmics, ja siguin a afegir o a eliminar, és a dir, positius o negatius: `(and ATOM1 ... ATOM_K)`

El predicat d'igualtat `(=)` òbviament no pot aparèixer en una fórmula d'efecte: cap acció pot fer que dues coses idèntiques no siguin idèntiques!

En un domini ADL, una fórmula d'efecte pot contenir, a més:
* Un efecte condicional: `(when FORMULA_CONDICIO FORMULA_EFECTE)` La interpretació és que l'efecte especificat té lloc només si la fórmula de condició especificada és certa en l'estat on s'executa l'acció. Els efectes condicionals sovint es col·loquen dins de quantificadors.
* Una fórmula quantificada universalment: `(forall (?V1 ?V2 ...) FORMULA_EFECTE)`

## Definició de Problema

La definició del problema (de vegades en diem la instància) conté els objectes presents en la instància del problema, la descripció de l'estat inicial i l'objectiu. 

### **El format de la definició del problema:**
```pddl
(define (problem NOM_DEL_PROBLEMA)
  (:domain NOM_DEL_DOMINI)
  (:objects OBJ1 OBJ2 ... OBJ_N)
  (:init ATOM1 ATOM2 ... ATOM_M)
  (:goal FORMULA_CONDICIO)
)
```

**Nota:** Alguns planners poden requerir que l'especificació `:requirements` aparegui també en la definició del problema (normalment just abans o just després de l'especificació `:domain`).

La descripció de l'estat inicial (la secció `:init`) és simplement una llista de tots els àtoms ground que són certs en l'estat inicial. Tots els altres àtoms ground són, per assumpció del mon tancat, falsos en l'estat inicial. La descripció de l'objectiu és una fórmula de la mateixa forma que una precondició d'acció. Tots els predicats utilitzats en la descripció de l'estat inicial i l'objectiu haurien de ser declarats naturalment en el domini corresponent.

A diferència de les precondicions d'acció, no obstant això, les descripcions de l'estat inicial i l'objectiu haurien de contenir àtoms *ground*, volent dir que tots els parametres de predicats haurien de ser noms d'objectes o constants en lloc de variables. Una excepció són els objectius quantificats en dominis ADL, on òbviament les variables quantificades poden ser utilitzades dins del context del quantificador. No obstant això, tingueu en compte que fins i tot alguns planners que afirmen admetre ADL no admeten quantificadors en objectius.

## Tipatge en PDDL

PDDL té una sintaxi (molt) especial per declarar els tipus de paràmetres i objectes. Si s'han d'utilitzar tipus en un domini, el domini hauria de declarar el requisit `:typing` a la part de `:requirements`. Els noms de tipus han de ser declarats abans que s'utilitzin (el que normalment significa abans de la declaració `:predicates`). Això es fa amb la declaració:

```pddl
(:types TIPUS1 TIPUS2 ...)
(:objects OBJ1 - TIPUS1 OBJ2 - TIPUS2)
```

Per declarar el tipus d'un paràmetre d'un predicat o acció s'escriu `?X - TIPUS_DE_X`. Una llista de paràmetres del mateix tipus es pot abreviar a `?X ?Y ?Z - TIPUS_DE_XYZ`. Noteu que el guió entre el paràmetre i el nom del tipus ha de ser "independent", *és a dir*, envoltat d'espais en blanc.

La sintaxi és la mateixa per declarar tipus d'objectes en la definició del problema.

En la declaració de tipus hi podem establir jerarquies mitjançant la relació de **subtipatge**. Per defecte hi ha un tipus que domina tots els altres que és `object`, per tant tots els objectes que declarem seran segur de tipus `object`. D'altra banda, imaginem que volem declarar el tipus `lloc` i el tipus `agent`, i que d'agents hi pot haver un `robot` i una `grua`, llavors ho faríem així:
```pddl
(:types
    lloc agent - object
    robot grua - agent
)
```

Seguint l'exemple, si tinguessim els objectes:
```pddl
(:objects
  l1 l2 - lloc
  r1 r2 r3 - robot
  g1 g2 - grua
)
```
i una acció fos:
```pddl
(:action a1
 (:parameters ?x - lloc ?y - robot ?z - agent)
 ...
)
```
aquesta acció podria prendre com a paràmetre `?x` només `l1` o `l2`, com a `?y` només `r1` o `r2` o `r3`, i com a `?`, tots els agents, és a dir: `r1`, `r2`, `r3`, `g1` i `g2`.



## Referències

Per a saber més de PDDL i planning en general us recomanem consultar la [wikipedia de planning](https://planning.wiki/). El material està molt bé, ben estructurat, molt complet d'acord amb els continguts del nostre curs i ple d'exemples il·lustratius.





