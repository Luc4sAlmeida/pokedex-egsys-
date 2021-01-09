import 'dart:ui';

import 'package:pokedex_egsys/style.dart';
import 'package:pokedex_egsys/widgets/pokemon_list_tile.dart';

import 'package:flutter/material.dart';

import 'package:pokedex_egsys/data/pokemon.dart';
import 'package:pokedex_egsys/widgets/base_view.dart';

import '../controller/home.dart';

class HomeScreenView extends WidgetView<HomeScreen, HomeScreenController> {
  HomeScreenView(HomeScreenController state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: AppBar(
        title: Text("Egsys Pokedex"),
        centerTitle: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: state.isSearchingForPokemon,
          child: CustomScrollView(
            controller: state.scrollController,
            slivers: [
              _buildSearchBar(context),
              _buildRandomButtonPokemon(context),
              _buildExploreTitle(context),
              _buildPokemonList(context)
            ],
          ),
        ),
        state.isSearchingForPokemon ? Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5
            ),
            child: Container(
              color: Colors.black.withOpacity(0)
            )
          )
        ) : SizedBox(),
        state.isSearchingForPokemon ? _buildSearchingForPokemon(context) : SizedBox(),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 70.0,
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Digite o nome ou tipo do pokémon...",
            labelStyle: TextStyle(color: Colors.grey[300], fontSize: 14)
          ),
          readOnly: true,
          onTap: state.onSearchPressed,
        ),
      ),
    );
  }

  Widget _buildRandomButtonPokemon(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton.icon(
          onPressed: state.onRandomButtonPressed, 
          icon: Icon(Icons.explore), 
          label: Text("Descubra um Pokémon!"),
          color: Colors.redAccent,
          textColor: Colors.white,
          elevation: 6,
        ),
      ),
    );
  }

  Widget _buildExploreTitle(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Explore", style: MyTypography.BIG.get().copyWith(color: Colors.grey[300])),
      ),
    );
  }

  Widget _buildPokemonList(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: state.model.pokemonNames, 
      builder: (context, pokemonNames, child) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => index < pokemonNames.length ? FutureBuilder<PokemonData>(
            future: state.model.getPokemonByName(pokemonNames[index]),
            builder: (context, snap) {
              if(snap.hasData) return GestureDetector(
                onTap: () => state.onPokemonPressed(snap.data),
                child: PokemonListTile(data: snap.data)
              );
              return PokemonLoadingListTile();
            },
          ) : _buildLoadingBottom(context),
          childCount: pokemonNames.length + 1,
        )
      )
    );
  }

  Widget _buildLoadingBottom(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
    ));
  }

  Widget _buildSearchingForPokemon(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text("Procurando um pokémon legal pra você ;)", style: MyTypography.MEDIUM.get().copyWith(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
