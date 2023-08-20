(*2.1 Echauffement *)

(*Question 1 *)

type string_builder =
    |Feuille of string * int 
    |N of string_builder * int * string_builder;;

let word str = Feuille(str, String.length(str));;

(*fonction auxiliaire taille qui renvoie le nombre de caractères d'un stringbuilder*)

let rec taille strb = match strb with 
  |Feuille(str,n) -> n
  |N(strb1,n,strb2) -> n;;


let rec concat strb1 strb2 = match strb1 with
  |Feuille(str,n) -> N(Feuille(str,n), n+(taille strb2), strb2) 
  |N(strbis1, n, strbis2) -> N(strbis1, n+(taille strb2), concat strbis2 strb2)
;;

(*tests question 1*)

let () = assert (word "nicolas" = Feuille("nicolas",7));;
let () = assert (concat (Feuille("nicolas",7)) (Feuille("desan",5)) = N(Feuille("nicolas",7), 12,Feuille("desan",5)));;

(*Question 2*)

let char_at i strb = 
  let rec aux strb = match strb with 
    |Feuille(str,n) -> str 
    |N(strb1,n,strb2) -> (aux strb1)^(aux strb2)
        ;
  in
  let str = aux strb in
    String.get str (i-1) 
;;  

(*tests question 2*)

let () = assert( char_at 10 (N(Feuille("nicolas",7), 13,Feuille("desan",5))) = 's');;

(*Question 3*)

(*fonction auxiliaire qui renvoie le début d'une chaine de caractères jusqu'au rang i*)

let rec sub_string_debut str i = match i with
  |0 -> ""
  |i -> (sub_string_debut str (i-1))^Char.escaped(String.get str (i-1))
;;

(*fonction auxiliaire qui renvoie le début d'une chaine de caractères sous forme de stringbuilder jusqu'au rang i*)

let rec debut strb i = match strb with
  |Feuille(str,n) when n>i -> Feuille(sub_string_debut str i,i)
  |Feuille(str,n) -> Feuille(str,n)
  |N(strb1, n, strb2) when n>i-> if (taille strb1)>i then (debut strb1 i) else N(strb1, i, debut strb2 (i-taille strb1))  
  |N(strb1, n, strb2) -> N(strb1,n,strb2)
;;

(*fonction auxiliaire qui renvoie une chaine de caractères du rang i jusqu'à la fin*)

let rec sub_string_fin str i = match i with
  |i when i=(String.length str)+1 -> ""
  |i -> Char.escaped(String.get str (i-1))^(sub_string_fin str (i+1))
;;

(*fonction auxiliaire qui renvoie une chaine de caractères du rang i jusqu'à la fin sous forme de stringbuilder*)

let rec fin strb i = match strb with
  |Feuille(str,n) when n>i -> Feuille(sub_string_fin str i,n-i+1)
  |Feuille(str,n) -> Feuille("",0)
  |N(strb1, n, strb2) when n>i -> if (taille strb1)<i then (fin strb2 (i-taille strb1)) 
      else N(fin strb1 i, (taille (fin strb1 i)) +(taille strb2), strb2)  
  |N(strb1, n, strb2) -> Feuille("",0)
;;


let sub_string strb i m=
  debut (fin strb i) m;;

(*tests question 3*)

let () = assert( sub_string (N(Feuille("nicolas",7), 13,Feuille("desan",5))) 5 5 = (N(Feuille("las",3), 5,Feuille("de",2))) );;

(*2.2 Equilibrage *)
(*Question 4*)

let cost strb = 
  let rec aux acc strb = match strb with
    |Feuille(str,n) -> n*acc
    |N(strb1,n,strb2) -> (aux (acc+1) strb1) + (aux (acc+1) strb2)
        ;
  in aux 0 strb
;;

(*tests question 4*)

let () = assert( cost (N(Feuille("nicolas",7), 16, N(Feuille("pile",4), 9,Feuille("desan",5)))) = 25);;

(* Question 5 *)

(*fonction auxiliaire qui génère un mot aléatoire*)

let random_word n = 
  let rec random_char n = match n with
    |0 -> ""
    |n -> Char.escaped (Char.chr (97 + (Random.int 26)))^(random_char (n-1))
        ; 
  in
    random_char (Random.int n);;


let random_string i =
  let rec aux i = match i with 
    |0 -> let str = random_word 5 in Feuille(str, (String.length str))
    |i -> let a = (Random.int 3) in
        let str = random_word 5 in 
          if a=0
          then let strb1,strb2 = (aux (i-1)), (aux (i-1)) in N(strb1, (taille strb1)+(taille strb2) , strb2)
          else if a=1
          then let strb1,strb2 = Feuille(str,String.length str), (aux (i-1)) in N(strb1, (taille strb1)+(taille strb2) , strb2)
          else 
            let strb1,strb2 =  (aux (i-1)), Feuille(str,String.length str) in N(strb1, (taille strb1)+(taille strb2) , strb2);
  in
    aux i;;

(*Question 6 *)

let rec concat_liste l1 l2 = match l1 with
  |[] -> l2
  |t::q -> t::(concat_liste q l2)
;;
  
let rec list_of_string strb = match strb with
  |Feuille(str, n) -> [Feuille(str,n)]
  |N(g,n,d) -> concat_liste (list_of_string g) (list_of_string d)
;;

(*test question 6*)

let () = assert( list_of_string (N(Feuille("nicolas",7), 16, N(Feuille("pile",4), 9,Feuille("desan",5)))) 
                 = [(Feuille("nicolas",7));(Feuille("pile",4));(Feuille("desan",5))]);;

(* Question 7 *)

let rec balance strb = 
  let min_cost l = match l with
    |[] -> failwith "erreur"
    |t::[] -> failwith "erreur"
    |t1::t2::q -> let rec aux tmp l = match l with
      |[] -> tmp 
      |t::[] -> tmp
      |t1::t2::q when (cost (concat t1 t2))<tmp -> aux (cost (concat t1 t2)) (t2::q) 
      |t1::t2::q -> aux tmp (t2::q)
          ;
        in
          aux (cost (concat t1 t2)) l
          ;
  
  in
  
  let rec retire_concat_insere l n = match l with 
    |[] -> failwith "erreur pas de n qui match"
    |t::[] -> failwith "erreur qu'un seul argument"
    |t1::t2::q when (cost (concat t1 t2))=n -> (concat t1 t2)::q 
    |t1::t2::q -> t1::(retire_concat_insere (t2::q) n)
        ;
  in
  let rec algo_final l = match l with
    |[] -> failwith "erreur il faut au moins un string builder"
    |[strb] -> strb 
    |[t1;t2] -> concat t1 t2 
    |t1::t2::q -> algo_final (retire_concat_insere l (min_cost l));
  in
    algo_final (list_of_string strb);;






