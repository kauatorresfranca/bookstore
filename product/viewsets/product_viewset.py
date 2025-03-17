from rest_framework.viewsets import ModelViewSet

from order.models import Product
from order.serializers.order_serializer import ProductSerializer

class ProductViewSet(ModelViewSet):

    serializer_class = ProductSerializer
    
    def get_queryset(self):
        return Product.objects.all()