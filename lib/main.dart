import 'package:flutter/material.dart'; // Importă biblioteca Material UI pentru widget-uri

void main() { // Funcția principală care rulează la lansare
  runApp(const MyApp()); // Inițializează aplicația cu widget-ul rădăcină MyApp
}

class MyApp extends StatefulWidget { // Widget care poate actualiza interfața când starea se schimbă
  const MyApp({super.key}); // Constructor care primește o cheie opțională

  @override
  State<MyApp> createState() => _MyAppState(); // Creează starea asociată widget-ului
}

class _MyAppState extends State<MyApp> { // Clasa de stare pentru MyApp
  bool _isPressed = false; // Stare booleană care urmărește dacă butonul este apăsat
  bool _isDoctor = true; // Stare booleană pentru comutarea între moduri (doctor/pacient)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF50341E), // Setează culoarea de fundal a scaffold-ului la maro închis (hex #50341E)

        body: Column( // Corpul paginii este un layout vertical (coloană)
          mainAxisAlignment: MainAxisAlignment.center, // Centrează conținutul pe verticală (axa principală)
          crossAxisAlignment: CrossAxisAlignment.center, // Centrează conținutul pe orizontală (axa transversală)
          children: [ // Lista de widget-uri copil
            Image.asset( // Widget pentru afișarea unei imagini din fișierele locale
              'assets/logo.jpeg', // Calea relativă către imagine în directorul assets
              width: 400, // Lățimea fixă a imaginii (400 de pixeli)
              height: 200, // Înălțimea fixă a imaginii (200 de pixeli)
              fit: BoxFit.cover, // Modul de redimensionare a imaginii (acoperă întreg spațiul)
           ),
            Padding( // Widget care adaugă spațiu în jurul copilului său
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // Spațiere: Stânga 30, sus 10, dreapta 30, jos 10
              child: Container( // Container pentru decorare și layout
                decoration: BoxDecoration( // Decorarea vizuală a containerului
                  borderRadius: BorderRadius.circular(100), // Colțuri rotunde cu raza mare (100)
                  boxShadow: [ // Adaugă umbre pentru efect de adâncime
                    BoxShadow(
                      color: Color(0xFF635448), // Culoare umbră maro închis
                      offset: Offset(6, 4.5), // Poziția umbrei (dreapta 6px, jos 4.5px)
                    ),
                  ],
                ),
                child: TextFormField( // Câmp de introducere text
                  keyboardType: TextInputType.name, // Tipul de tastatură optimizat pentru nume
                  decoration: InputDecoration( // Personalizarea aspectului câmpului
                    labelStyle: TextStyle(color: Colors.white), // Stil text label (alb)
                    hintText: 'Full Name', // Text indiciu în câmpul gol
                    hintStyle: TextStyle(color: Colors.white), // Stil text indiciu (alb)
                    prefixIcon: Icon( // Iconiță în fața câmpului
                        Icons.person, // Pictograma persoanei
                        color: Colors.white // Culoare albă pentru iconiță
                    ),
                    border: OutlineInputBorder( // Stilul chenarului
                      borderRadius: BorderRadius.circular(100.0), // Rotunjire mare (100px)
                      borderSide: BorderSide.none, // Elimină linia de bordură
                    ),
                    filled: true, // Activează fundal colorat
                    fillColor: Color(0xFF837163), // Culoare de fundal maro deschis
                    contentPadding: EdgeInsets.symmetric( // Spațiere internă
                        vertical: 8, // Spațiu vertical mic (8px)
                        horizontal: 10 // Spațiu orizontal mic (10px)
                    ),
                    isDense: true, // Reduce spațierea internă implicită
                  ),
                  style: TextStyle(fontSize: 14), // Stil text introdus (dimensiune 14)
                  onChanged: (String value) { // Callback la schimbarea textului
                    // Poți adăuga logică aici pentru gestionarea input-ului
                  },
                ),
              ),
            ),
            Padding( // Widget care adaugă spațiere în jurul copilului său
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // 🔵 Spațiere: 30px stânga/dreapta, 10px sus/jos
              child: Container( // Container pentru decorare suplimentară
                decoration: BoxDecoration( // Decorarea vizuală a containerului
                  borderRadius: BorderRadius.circular(100), // Colțuri rotunde perfecte (raza 100)
                  boxShadow: [ // Listă de efecte de umbră
                    BoxShadow( // Umbra personalizată
                      color: Color(0xFF635448), // Culoare umbră maro-închis (#635448)
                      offset: Offset(6, 4.5), // Poziționare umbră (6px dreapta, 4.5px jos)
                    ),
                  ],
                ),
                child: TextFormField( // Câmp de introducere text pentru email
                  keyboardType: TextInputType.emailAddress, // Tastatură optimizată pentru email
                  decoration: InputDecoration( // Personalizare aspect câmp
                    labelStyle: TextStyle(color: Colors.white), // Culoare albă pentru label
                    hintText: 'Email', // Text sugestie în câmpul gol
                    hintStyle: TextStyle(color: Colors.white), // Culoare albă pentru hint
                    prefixIcon: Icon( // Pictogramă în fața câmpului
                        Icons.email, // Pictograma de email
                        color: Colors.white // Culoare albă pentru pictogramă
                    ),
                    border: OutlineInputBorder( // Stilul chenarului
                      borderRadius: BorderRadius.circular(100.0), // Rotunjire mare (100px)
                      borderSide: BorderSide.none, // Elimină linia de bordură
                    ),
                    filled: true, // Activează fundal colorat
                    fillColor: Color(0xFF837163), // Culoare fundal maro-deschis (#837163)
                    contentPadding: EdgeInsets.symmetric( // Spațiere internă
                        vertical: 8, // 8px sus/jos
                        horizontal: 10 // 10px stânga/dreapta
                    ),
                    isDense: true, // Reduce spațierea internă implicită
                  ),
                  style: TextStyle(fontSize: 14), // Dimensiune text 14px
                  onChanged: (String value) { // Callback la schimbarea textului
                    // Poți adăuga aici logica pentru validare email
                  },
                ),
              ),
            ),
            Padding( // Widget pentru spațiere în jurul câmpului
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // 🔵 Spațiere: 30px stânga/dreapta, 10px sus/jos
              child: Container( // Container pentru efecte vizuale suplimentare
                decoration: BoxDecoration( // Decorarea vizuală a containerului
                  borderRadius: BorderRadius.circular(100), // Formă rotundă perfectă (raza 100px)
                  boxShadow: [ // Listă de umbre
                    BoxShadow( // Configurare umbră
                      color: Color(0xFF635448), // Culoare umbră maro-închis (#635448)
                      offset: Offset(6, 4.5), // Poziționare umbră (6px dreapta, 4.5px jos)
                    ),
                  ],
                ),
                child: TextFormField( // Câmp de introducere text pentru ID
                  keyboardType: TextInputType.number, // Tastatură numerică optimizată
                  decoration: InputDecoration( // Personalizare aspect câmp
                    labelStyle: TextStyle(color: Colors.white), // Culoare albă pentru textul label
                    hintText: 'ID', // Text sugestie în câmpul gol
                    hintStyle: TextStyle(color: Colors.white), // Culoare albă pentru textul sugestie
                    prefixIcon: Icon( // Pictogramă înaintea câmpului
                        Icons.perm_identity, // Pictograma de identitate
                        color: Colors.white // Culoare albă pentru pictogramă
                    ),
                    border: OutlineInputBorder( // Stilul chenarului
                      borderRadius: BorderRadius.circular(100.0), // Rotunjire mare (100px)
                      borderSide: BorderSide.none, // Elimină linia de bordură vizibilă
                    ),
                    filled: true, // Activează fundal colorat
                    fillColor: Color(0xFF837163), // Culoare fundal maro-deschis (#837163)
                    contentPadding: EdgeInsets.symmetric( // Spațiere internă
                        vertical: 8, // 8px sus/jos
                        horizontal: 10 // 10px stânga/dreapta
                    ),
                    isDense: true, // Reduce spațierea internă implicită
                  ),
                  style: TextStyle(fontSize: 14), // Dimensiune text 14px
                  onChanged: (String value) { // Callback la schimbarea valorii
                    // Poți adăuga aici validări sau logica pentru ID
                  },
                ),
              ),
            ),
            Padding( // Adaugă spațiu în jurul câmpului de parolă
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // Spațiere: 30 stânga/dreapta, 10 sus/jos
              child: Container( // Container pentru decorarea câmpului
                decoration: BoxDecoration( // Stilizarea vizuală a containerului
                  borderRadius: BorderRadius.circular(100), // Colțuri rotunde perfecte (rază 100px)
                  boxShadow: [ // Listă de efecte de umbră
                    BoxShadow( // Configurare umbră
                      color: Color(0xFF635448), // Culoare umbră maro-închis (#635448)
                      offset: Offset(6, 4.5), // Poziționare umbră (6px dreapta, 4.5px jos)
                    ),
                  ],
                ),
                child: TextFormField( // Câmp de introducere text pentru parolă
                  keyboardType: TextInputType.emailAddress, // Tip tastatură (poate fi TextInputType.visiblePassword)
                  obscureText: true, // Ascunde caracterele introduse (afișează buline)
                  decoration: InputDecoration( // Personalizarea aspectului câmpului
                    labelStyle: TextStyle(color: Colors.white), // Culoare albă pentru etichetă
                    hintText: 'Password', // Text indiciu în câmpul gol
                    hintStyle: TextStyle(color: Colors.white), // Culoare albă pentru textul indiciu
                    prefixIcon: Icon( // Pictogramă în partea stângă
                        Icons.lock, // Pictograma lacăt
                        color: Colors.white // Culoare albă pentru pictogramă
                    ),
                    border: OutlineInputBorder( // Stilul chenarului
                      borderRadius: BorderRadius.circular(100.0), // Rotunjire 100px
                      borderSide: BorderSide.none, // Elimină linia de bordură
                    ),
                    filled: true, // Activează fundal colorat
                    fillColor: Color(0xFF837163), // Culoare fundal maro-deschis (#837163)
                    contentPadding: EdgeInsets.symmetric( // Spațiere internă
                        vertical: 8, // 8px sus/jos
                        horizontal: 10 // 10px stânga/dreapta
                    ),
                    isDense: true, // Reduce spațierea implicită
                  ),
                  style: TextStyle(fontSize: 14), // Dimensiune text 14px
                  onChanged: (String value) { // Funcție apelată la schimbarea textului
                    // Poți adăuga aici validarea parolei
                  },
                ),
              ),
            ),
              Padding( // Widget care adaugă spațiu în jurul câmpului
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // Spațiere: 30 stânga, 10 sus, 30 dreapta, 10 jos
                child: Container( // Container pentru efecte vizuale suplimentare
                  decoration: BoxDecoration( // Decorarea containerului
                    borderRadius: BorderRadius.circular(100), // Colțuri rotunde perfecte (rază mare)
                    boxShadow: [ // Listă de umbre
                      BoxShadow( // Configurare umbră
                        color: Color(0xFF635448), // Culoare umbră maro-închis
                        offset: Offset(6, 4.5), // Poziționare umbră (dreapta/jos)
                      ),
                    ],
                  ),
                  child: TextFormField( // Câmp de formular pentru text
                      keyboardType: TextInputType.emailAddress, // Tip tastatură (ar putea fi visiblePassword)
                      obscureText: true, // Ascunde caracterele introduse
                      decoration: InputDecoration( // Personalizare aspect câmp
                        labelStyle: TextStyle(color: Colors.white), // Stil text etichetă (alb)
                        hintText: 'Re-enter Password', // Text de ajutor
                        hintStyle: TextStyle(color: Colors.white), // Stil text ajutor (alb)
                        prefixIcon: Icon( // Iconiță prefixată
                            Icons.lock, // Pictograma lacăt
                            color: Colors.white // Albă
                        ),
                        border: OutlineInputBorder( // Stil bordură
                          borderRadius: BorderRadius.circular(100.0), // Rotunjire mare
                          borderSide: BorderSide.none, // Fără bordură vizibilă
                        ),
                        filled: true, // Fundal colorat
                        fillColor: Color(0xFF837163), // Culoare fundal maro-deschis
                        contentPadding: EdgeInsets.symmetric( // Spațiere internă
                            vertical: 8, // 8px sus/jos
                            horizontal: 10 // 10px stânga/dreapta
                        ),
                        isDense: true, // Spațiere compactă
                      ),
                      style: TextStyle(fontSize: 14), // Dimensiune text mică (14px)
                      onChanged: (String value){ // Callback la schimbare text
                        // Loc pentru validare personalizată
                      }
                  ),
                ),
              ),

            Padding( // Adaugă spațiu în jurul întregului component
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // Spațiere: 30 stânga/dreapta, 10 sus/jos
              child: GestureDetector( // Detectează evenimente de atingere
                onTap: () { // Acțiune la apăsare
                  setState(() { // Actualizează interfața
                    _isDoctor = !_isDoctor; // Schimbă starea între doctor/pacient
                  });
                },
                child: Container( // Containerul principal
                  width: 120, // Lățime totală
                  height: 60, // Înălțime totală
                  decoration: BoxDecoration( // Stilizare container
                    color: Colors.grey[200], // Fundal gri deschis
                    borderRadius: BorderRadius.circular(30), // Colțuri rotunde (jumătate din înălțime)
                  ),
                  child: Stack( // Permite suprapunerea widget-urilor
                    children: [
                      AnimatedPositioned( // Animatie de mișcare
                        duration: Duration(milliseconds: 300), // Durată animație 300ms
                        left: _isDoctor ? 0 : 60, // Poziționare pe orizontală (0 sau 60px)
                        child: Container( // Butonul circular mobil
                          width: 60, // Diametru cerc
                          height: 60, // Diametru cerc
                          decoration: BoxDecoration(
                            color: _isDoctor ? Colors.blue : Colors.green, // Albastru pentru doctor, verde pentru pacient
                            shape: BoxShape.circle, // Formă perfect circulară
                          ),
                          child: Icon( // Pictogramă în buton
                            _isDoctor ? Icons.medical_services : Icons.person, // Stetoscop sau persoană
                            color: Colors.white, // Pictogramă albă
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center( // Centrează conținutul pe ecran
              child: GestureDetector( // Detectează interacțiuni tactile
                onTapDown: (_) => setState(() => _isPressed = true), // Apăsare buton - starea devine true
                onTapUp: (_) => setState(() => _isPressed = false), // Eliberare buton - starea devine false
                onTapCancel: () => setState(() => _isPressed = false), // Anulare tactilă - resetează starea
                child: AnimatedContainer( // Container cu animație
                  duration: const Duration(milliseconds: 20), // Durată animație extrem de rapidă (20ms)
                  transform: Matrix4.translationValues( // Transformare de poziție
                      _isPressed ? 6 : 0, // Pe orizontală: 6px când e apăsat, 0 altfel
                      _isPressed ? 4.5 : 0, // Pe verticală: 4.5px când e apăsat, 0 altfel
                      0 // Pe axa Z (adâncime) - niciun efect
                  ),
                  decoration: BoxDecoration( // Decorarea vizuală
                    borderRadius: BorderRadius.circular(100), // Colțuri perfect rotunde
                    boxShadow: _isPressed // Umbra condiționată
                        ? [] // Fără umbră când butonul este apăsat
                        : [
                      const BoxShadow( // Umbră când butonul nu e apăsat
                        color: Color(0xFF635448), // Culoare umbră maro-închis
                        offset: Offset(6, 4.5), // Poziție umbră (6px dreapta, 4.5px jos)
                        blurRadius: 0, // Fără estompare
                      ),
                    ],
                  ),
                  child: ElevatedButton( // Buton material ridicat
                    onPressed: () { // Acțiune la apăsare
                      ScaffoldMessenger.of(context).showSnackBar( // Afișează mesaj pop-up
                        const SnackBar(content: Text('Butonul funcționează!')), // Conținut mesaj
                      );
                    },
                    style: ElevatedButton.styleFrom( // Stilizare personalizată
                      backgroundColor: const Color(0xFF837163), // Fundal maro-deschis
                      foregroundColor: const Color(0xFFDF965A), // Culoare text portocaliu-deschis
                      shadowColor: Colors.transparent, // Fără umbră proprie
                      elevation: 0, // Fără efect de ridicare
                      padding: const EdgeInsets.symmetric( // Spațiere internă
                          horizontal: 24, vertical: 16), // 24px stânga/dreapta, 16px sus/jos
                      shape: RoundedRectangleBorder( // Formă personalizată
                        borderRadius: BorderRadius.circular(100), // Colțuri perfect rotunde
                      ),
                    ),
                    child: const Text( // Text buton
                      'Sign up',
                      style: TextStyle( // Stil text
                        fontSize: 18, // Dimensiune mare (18px)
                        fontWeight: FontWeight.bold, // Text îngroșat
                      ),
                    ),
                  ),
                ),
              ),
            ),],
      ),
    ),
    );
  }
}