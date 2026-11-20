import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/order_card.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orderProvider = context.watch<OrderProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          title: const Text('My Orders'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: isDark ? AppColors.secondary : AppColors.primary,
            labelColor: isDark ? AppColors.secondary : AppColors.primary,
            unselectedLabelColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'All Orders'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: TabBarView(
                children: [
                  _buildOrdersList(context, orderProvider.allOrders, isDark),
                  _buildOrdersList(context, orderProvider.activeOrders, isDark),
                  _buildOrdersList(context, orderProvider.completedOrders, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<OrderModel> orders,
    bool isDark,
  ) {
    if (orders.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          icon: Icons.receipt_long_outlined,
          title: 'No orders found',
          description:
              'You don\'t have any orders in this section yet. Order fresh groceries today!',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onViewDetails: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(order: order),
              ),
            );
          },
        );
      },
    );
  }
}
