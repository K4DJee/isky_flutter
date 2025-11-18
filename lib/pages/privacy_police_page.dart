import 'package:flutter/material.dart';
import 'package:iskai/l10n/app_localizations.dart';

class PrivacyPolicePage extends StatefulWidget{
  const PrivacyPolicePage({super.key});

  @override
  State<PrivacyPolicePage> createState() => _PrivacyPolicePageState();
}

class _PrivacyPolicePageState extends State<PrivacyPolicePage>{
 @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
   return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicyTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyPolicyHeader,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.privacyPolicyLastUpdated,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(l10n.privacyPolicyWelcome),
            const SizedBox(height: 8),
            Text(l10n.privacyPolicyAgreement),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection1Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n.privacyPolicySection1Description),
            const SizedBox(height: 8),
            Text(
              l10n.privacyPolicySection1_1Title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection1_1DictionaryContent),
            Text(l10n.privacyPolicySection1_1SyncData),
            const SizedBox(height: 8),
            Text(
              l10n.privacyPolicySection1_2Title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection1_2TechnicalInfo),
            Text(l10n.privacyPolicySection1_2UsageData),
            Text(l10n.privacyPolicySection1_2AdData),
            const SizedBox(height: 8),
            Text(l10n.privacyPolicyNoSensitiveData),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection2Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection2Services),
            Text(l10n.privacyPolicySection2Improvement),
            Text(l10n.privacyPolicySection2Ads),
            Text(l10n.privacyPolicySection2Legal),
            const SizedBox(height: 8),
            Text(l10n.privacyPolicyNoSellingData),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection3Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection3YandexAds),
            Text(l10n.privacyPolicySection3SyncServers),
            Text(l10n.privacyPolicySection3OtherCases),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection4Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection4LocalStorage),
            Text(l10n.privacyPolicySection4Sync),
            Text(l10n.privacyPolicySection4Retention),
            Text(l10n.privacyPolicySection4Security),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection5Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection5RightsIntro),
            Text(l10n.privacyPolicySection5Access),
            Text(l10n.privacyPolicySection5Correction),
            Text(l10n.privacyPolicySection5Deletion),
            Text(l10n.privacyPolicySection5Complaint),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection7Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection7Changes),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicySection8Title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(l10n.privacyPolicySection8Questions),
            Text(l10n.privacyPolicySection8Developer),
            Text(l10n.privacyPolicySection8Email),
            Text(l10n.privacyPolicySection8Studio),
            const SizedBox(height: 16),
            Text(l10n.privacyPolicyThanks),
          ],
        ),
      ),
    );
  }
}
