import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';

class ModernWalletCard extends StatefulWidget {
  const ModernWalletCard({
    required this.title,
    required this.balance,
    required this.themeColor,
    required this.isConnected,
    required this.isXmlWallet,
    this.onTopUpTap,
    this.onTransferTap,
    this.onQrisTap,
    this.onConnectTap,
    super.key,
  });

  final String title;
  final int balance;
  final Color themeColor;
  final bool isConnected;
  final bool isXmlWallet; // Flag baru

  final VoidCallback? onTopUpTap;
  final VoidCallback? onTransferTap;
  final VoidCallback? onQrisTap;
  final VoidCallback? onConnectTap;

  @override
  State<ModernWalletCard> createState() => _ModernWalletCardState();
}

class _ModernWalletCardState extends State<ModernWalletCard> {
  bool _isSaldoHidden = false;

  @override
  Widget build(BuildContext context) {
    // Gradient Background
    final Gradient bgGradient = LinearGradient(
      colors: [
        widget.themeColor,
        HSLColor.fromColor(widget.themeColor).withLightness(0.45).toColor(),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: bgGradient,
            borderRadius: .circular(28),
            boxShadow: [
              BoxShadow(
                color: widget.themeColor.withAlpha(75),
                blurRadius: 25,
                offset: const Offset(0, 20),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: .circular(28),
            child: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: kWhite.withAlpha(20),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: kWhite.withAlpha(20),
                  ),
                ),

                // konten utama
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: .centerLeft,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .start,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 12),
                              _buildBalance(),
                              const SizedBox(height: 20),
                              _buildBottomArea(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 1. Header (Nama Wallet & Logo)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Container(
                padding: const .all(6),
                decoration: BoxDecoration(
                  color: kWhite.withAlpha(50),
                  borderRadius: .circular(10),
                ),
                child: const Icon(Icons.wallet, color: kWhite, size: 18),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.title.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: .w600,
                    letterSpacing: 0.5,
                    color: kWhite,
                  ),
                  overflow: .ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Logo Provider Placeholder
        Container(
          height: 20,
          padding: const .symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: kWhite.withAlpha(230),
            borderRadius: .circular(4),
          ),
          child: Center(
            child: Text(
              "PROVIDER",
              style: TextStyle(
                fontSize: 9,
                fontWeight: .w900,
                color: widget.themeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 2. Saldo Area
  Widget _buildBalance() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Total Saldo',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: .w500,
            color: kWhite.withAlpha(200),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: .scaleDown,
                alignment: .centerLeft,
                child: Text(
                  _isSaldoHidden
                      ? 'Rp ••••••••'
                      : CurrencyUtil.formatCurrency(widget.balance),
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: .w700,
                    color: kWhite,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol Hide/Show Saldo
            InkWell(
              onTap: () => setState(() => _isSaldoHidden = !_isSaldoHidden),
              borderRadius: .circular(20),
              child: Padding(
                padding: const .all(6.0),
                child: Icon(
                  _isSaldoHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kWhite.withAlpha(200),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Bottom Area
  Widget _buildBottomArea() {
    if (!widget.isConnected && !widget.isXmlWallet) {
      return _buildConnectButton();
    }
    if (!widget.isConnected && widget.isXmlWallet) {
      return _buildXmlStatusBadge();
    }
    return _buildActionMenu();
  }

  // --- Opsi Tampilan Bawah ---

  // Opsi A: Tombol Hubungkan Akun
  Widget _buildConnectButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: widget.onConnectTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kWhite,
          foregroundColor: widget.themeColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'Hubungkan Akun',
              style: GoogleFonts.inter(fontWeight: .w700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Opsi B: Badge Cantik untuk Saldo XML (Pengganti tombol)
  Widget _buildXmlStatusBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kWhite.withAlpha(40),
        borderRadius: .circular(16),
        border: Border.all(color: kWhite.withAlpha(40), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stars_rounded, color: kYellow, size: 20),
          const SizedBox(width: 8),
          Text(
            "Basic Member", // Atau "Akun Aktif"
            style: GoogleFonts.inter(
              color: kWhite.withAlpha(230),
              fontSize: 13,
              fontWeight: .w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Opsi C: Menu Aksi (Topup, Transfer, QRIS)
  Widget _buildActionMenu() {
    return Container(
      padding: const EdgeInsets.all(12), // Padding diperkecil agar muat
      decoration: BoxDecoration(
        color: kWhite.withAlpha(40),
        borderRadius: .circular(20),
        border: Border.all(color: kWhite.withAlpha(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute evenly
        children: [
          _buildMenuItem(
            icon: Icons.add_circle_outline_rounded,
            label: 'Top Up',
            onTap: widget.onTopUpTap,
          ),
          _buildVerticalDivider(),
          _buildMenuItem(
            icon: Icons.swap_horiz_rounded,
            label: 'Transfer',
            onTap: widget.onTransferTap,
          ),
          _buildVerticalDivider(),
          _buildMenuItem(
            icon: Icons.qr_code_scanner_rounded,
            label: 'QRIS',
            isHighlight: true, // Tombol QRIS beda sendiri
            onTap: widget.onQrisTap,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 24, width: 1, color: kWhite.withAlpha(50));
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool isHighlight = false,
  }) {
    // Opacity logic: Jika onTap null, tombol terlihat redup
    return Expanded(
      // Gunakan Expanded agar area klik luas dan rata
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: Opacity(
          opacity: onTap != null ? 1.0 : 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isHighlight ? kWhite : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isHighlight ? widget.themeColor : kWhite,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10, // Ukuran font aman
                  fontWeight: isHighlight ? .w700 : .w500,
                  color: kWhite,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
