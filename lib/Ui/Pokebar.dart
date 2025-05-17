import 'package:flutter/material.dart';

class PokemonStatBar extends StatelessWidget {
  final String statName;
  final int statValue;
  final int maxValue; // Nuevo: Valor máximo para la barra
  final Color fillColor;
  final Color emptyColor;
  final double height;

  const PokemonStatBar({
    Key? key,
    required this.statName,
    required this.statValue,
    this.maxValue = 100, // Predeterminado a 100, pero puede ser diferente
    this.fillColor = const Color(0xFF388E3C), // Verde oscuro
    this.emptyColor = const Color(0xFF81C784), // Verde claro
    this.height = 10,
  })  : assert(statValue >= 0, 'statValue must be greater than or equal to 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double fillPercentage = (statValue / maxValue).clamp(0, 1); // Clamp para asegurar 0-1

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80, // Ancho fijo para el nombre de la estadística
            child: Text(
              statName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: emptyColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: height,
                  width: (MediaQuery.of(context).size.width - 100) *
                      fillPercentage, // Ancho dinámico
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30, // Ancho fijo para el valor
            child: Text(
              statValue.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}