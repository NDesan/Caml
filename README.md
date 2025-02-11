# String builders

## Enoncé du projet 

La majorité des langages de programmation fournissent une notion primitive de chaîne de caractères. Si ces chaînes s’avèrent adaptées à la manipulation de mots ou de textes relativement courts, elles deviennent généralement inutilisables sur de très grands textes. L’une des raisons de cette inefficacité est la duplication d’un trop grand nombre de caractères lors des opérations de concaténation ou l’extraction d’une sous-chaîne.

Or, il existe des domaines où la manipulation efficace de grandes chaînes de caractères est essentielle (représentation du génome en bio-informatique, éditeurs de texte, ...). Ce projet propose une alternative à la notion usuelle de chaîne de caractères que nous appelons string_builder. Un string_builder est un arbre binaire, dont les feuilles sont des chaînes de caractères usuelles et dont les noeuds internes représentent des concaténations.

