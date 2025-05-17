import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapi_flutter/Ui/Pokebar.dart';
import 'package:pokeapi_flutter/model/pode_model.dart';
import 'package:pokeapi_flutter/model/poke_details.dart';

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  List<Pokemon> _pokemons = [];
  String _query = '';
  bool _isLoading = true;
  String _errorMessage = '';
  

  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  Future<void> fetchPokemons() async {
    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Error al cargar la lista de Pokémon: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      List results = data['results'];

      final List<Pokemon> detailedPokemons = await Future.wait(
        results.map((poke) async {
          final res = await http.get(Uri.parse(poke['url']));
          if (res.statusCode != 200) {
            throw Exception(
                'Error al cargar detalles del Pokémon ${poke['name']}: ${res.statusCode}');
          }
          final detail = jsonDecode(res.body);
          return Pokemon.fromJson(detail);
        }),
      );

      setState(() {
        _pokemons = detailedPokemons;
        _isLoading = false;
        _errorMessage = ''; // Limpia cualquier mensaje de error anterior
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _pokemons.where((p) {
      final queryId = int.tryParse(_query);
      if (queryId != null) {
        return p.id == queryId;
      } else {
        return p.name.toLowerCase().contains(_query.toLowerCase());
      }
    }).toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          'Error: $_errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Pokedex')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Row(
              children: [
                Text("Hola, ",style: TextStyle(fontSize: 25),),
                Text("bienvenido!",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
               border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                labelText: 'Buscar',
                suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(26),
              children: List.generate(filtered.length, (index) {
                final poke = filtered[index];
                return Card(
                  child: InkWell(
                    onTap: () => Navigator.push(
                     context,
                     MaterialPageRoute(builder: (_) => PokemonDetail(pokemon: poke)),
                   ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '#${index + 1}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(poke.sprites.other!.home!.frontDefault!),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              poke.name,
                              textAlign: TextAlign.start,
                    
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF01426A),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                // ListTile(
                //   title: Text(poke.name),
                //   leading: Image.network(poke.imageUrl),
                //   onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => PokemonDetail(pokemon: poke)),
                //   ),
                // );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class PokemonDetail extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetail({required this.pokemon});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Text(widget.pokemon.name),
          
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                          widget.pokemon.sprites.other!.home!.frontDefault!,
                        ),
                        fit: BoxFit.contain
                        )
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 70,
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.pokemon.types.length,
                        itemBuilder: (context, index){
                          final type = widget.pokemon.types[index];
                          return  Row(
                        children: [
                          Chip(label: Text("${type.type.name}")),
                          SizedBox(width: 8,),
                        ],
                      );
                        }
                      ),
                    )
                    
                  )
                ],
              ),
            ),
            // Container(
            //   color: const Color(0xFF65D498),
            //   child: Image.network(pokemon.sprites.other!.home!.frontDefault!),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.monitor_weight_outlined,size: 30,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.pokemon.weight} kg"),
                      Text("Peso"),
                    ],
                  ),
                  Container(color: Colors.black, width: 1,),
                  Icon(Icons.height),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${widget.pokemon.height} m"),
                      Text("Altura"),
                    ],
                  ),
                ],
              ),
            ),
            //Flexible(child: Text(filtered.last.pokedata.reversed.)),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: widget.pokemon.stats.length,
                itemBuilder: (context, index){
                  final start = widget.pokemon.stats[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: 
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                        PokemonStatBar(statName: start.stat.name, statValue: start.baseStat)
                        
                    //   ],
                    // ),
                  );
                },
                
              ),
            )
          ],
        ),
      )
    );
  }
}
