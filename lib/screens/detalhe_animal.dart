import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/animal.dart';
import '../utils/constants.dart';

class DetalheAnimal extends StatelessWidget {
  final Animal animal;

  const DetalheAnimal({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(animal.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.pets,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              animal.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(context),
            const SizedBox(height: 16),
            if (animal.observacoes.isNotEmpty) ...[
              _buildObservacoesCard(),
              const SizedBox(height: 16),
            ],
            if (animal.nfcTagId != null) ...[
              _buildNfcCard(),
              const SizedBox(height: 16),
            ],
            _buildQrCodeCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.monitor_weight,
              'Peso',
              '${animal.peso} kg',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Idade',
              '${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.fingerprint,
              'ID',
              animal.id.substring(0, 8).toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildObservacoesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notes, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Observações',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              animal.observacoes,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNfcCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.nfc, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tag NFC Associada',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  animal.nfcTagId!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCodeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'QR Code do Animal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: animal.id,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.roundedOuter,
                color: AppColors.primary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.roundedOuter,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${animal.id.substring(0, 8).toUpperCase()}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
