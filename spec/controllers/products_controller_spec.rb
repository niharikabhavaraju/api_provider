require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      product = Product.create(name: 'Test Product', price: 9.99)
      get :show, params: { id: product.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: { name: 'New Product', price: 9.99 } }
        }.to change(Product, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { product: { name: 'New Product', price: 9.99 } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        post :create, params: { product: { name: '', price: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:product) { Product.create(name: 'Test Product', price: 9.99) }

    context 'with valid parameters' do
      it 'updates the requested product' do
        patch :update, params: { id: product.id, product: { name: 'Updated Product' } }
        product.reload
        expect(product.name).to eq('Updated Product')
      end

      it 'returns a success response' do
        patch :update, params: { id: product.id, product: { name: 'Updated Product' } }
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        patch :update, params: { id: product.id, product: { name: '', price: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { Product.create(name: 'Test Product', price: 9.99) }

    it 'destroys the requested product' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
    end

    it 'redirects to the products index page' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_path)
    end
  end
end
