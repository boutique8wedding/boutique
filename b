import React, { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { motion } from "framer-motion";
import { ShoppingCart, Search, ArrowLeft, Globe } from "lucide-react";

// بيانات الترجمة للغات
const translations = {
  ar: {
    shopTitle: "بوتيك - فساتين الزفاف",
    searchPlaceholder: "ابحث عن فستان...",
    maxPricePlaceholder: "السعر الأقصى",
    sellerLabel: "البائعة",
    back: "رجوع",
    dressesOf: "فساتين",
    contact: "تواصل مع البائعة",
    langToggle: "English"
  },
  en: {
    shopTitle: "Boutique - Wedding Dresses",
    searchPlaceholder: "Search for a dress...",
    maxPricePlaceholder: "Max price",
    sellerLabel: "Seller",
    back: "Back",
    dressesOf: "Dresses of",
    contact: "Contact Seller",
    langToggle: "العربية"
  }
};

const dresses = [
  { id: 1, title: { ar: "فستان زفاف ملكي", en: "Royal Wedding Dress" }, price: 3500, image: "/images/dress1.jpg", seller: "علياء محمد" },
  { id: 2, title: { ar: "فستان دانتيل أنيق", en: "Elegant Lace Dress" }, price: 2700, image: "/images/dress2.jpg", seller: "ندى السبيعي" },
  { id: 3, title: { ar: "فستان بسيط وراقي", en: "Simple & Chic Dress" }, price: 2000, image: "/images/dress3.jpg", seller: "سارة العتيبي" }
];

const sellers = [...new Set(dresses.map(d => d.seller))];

function SellerPage({ sellerName, onBack, lang }) {
  const t = translations[lang];
  const sellerDresses = dresses.filter(d => d.seller === sellerName);

  return (
    <div className="p-6 space-y-6 max-w-6xl mx-auto">
      <Button variant="ghost" onClick={onBack} className="flex items-center gap-2">
        <ArrowLeft /> {t.back}
      </Button>
      <h2 className="text-2xl font-bold mb-4">{t.dressesOf} {sellerName}</h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {sellerDresses.map(dress => (
          <motion.div key={dress.id} whileHover={{ scale: 1.03 }} className="rounded-2xl shadow-md overflow-hidden">
            <Card className="p-0">
              <img src={dress.image} alt={dress.title[lang]} className="w-full h-64 object-cover" />
              <CardContent className="p-4 space-y-2">
                <h2 className="text-xl font-semibold">{dress.title[lang]}</h2>
                <p className="text-lg font-bold text-pink-600">{dress.price.toLocaleString()} {lang === 'ar' ? 'ريال' : 'SAR'}</p>
                <Button className="w-full"><ShoppingCart className="mr-2" /> {t.contact}</Button>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>
    </div>
  );
}

export default function Boutique() {
  const [filter, setFilter] = useState({ seller: "", maxPrice: "" });
  const [route, setRoute] = useState(window.location.hash);
  const [lang, setLang] = useState("ar");

  window.onhashchange = () => setRoute(window.location.hash);

  const t = translations[lang];
  const filteredDresses = dresses.filter(d => {
    return (!filter.seller || d.seller === filter.seller) &&
           (!filter.maxPrice || d.price <= parseInt(filter.maxPrice));
  });

  const sellerMatch = route.match(/#\/seller\/(.+)/);
  if (sellerMatch) {
    const sellerName = decodeURIComponent(sellerMatch[1]);
    return <SellerPage sellerName={sellerName} onBack={() => (window.location.hash = "")} lang={lang} />;
  }

  return (
    <div className="p-6 space-y-6 max-w-6xl mx-auto">
      <div className="flex justify-between items-center flex-wrap gap-4">
        <h1 className="text-3xl font-bold">{t.shopTitle}</h1>
        <div className="flex items-center gap-2">
          <Button variant="outline" onClick={() => setLang(lang === 'ar' ? 'en' : 'ar')} className="flex items-center gap-1">
            <Globe size={16} /> {t.langToggle}
          </Button>
          <Input
            placeholder={t.searchPlaceholder}
            className="w-64"
            onChange={e => setFilter({ ...filter, seller: e.target.value })}
            list="sellers"
          />
          <datalist id="sellers">
            {sellers.map((seller, i) => (<option key={i} value={seller} />))}
          </datalist>
          <Input
            type="number"
            placeholder={t.maxPricePlaceholder}
            className="w-40"
            onChange={e => setFilter({ ...filter, maxPrice: e.target.value })}
          />
          <Button variant="outline"><Search /></Button>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
        {filteredDresses.map(dress => (
          <motion.div key={dress.id} whileHover={{ scale: 1.03 }} className="rounded-2xl shadow-md overflow-hidden">
            <Card className="p-0">
              <img src={dress.image} alt={dress.title[lang]} className="w-full h-64 object-cover" />
              <CardContent className="p-4 space-y-2">
                <h2 className="text-xl font-semibold">{dress.title[lang]}</h2>
                <a href={`#/seller/${encodeURIComponent(dress.seller)}`} className="text-sm text-blue-600 hover:underline">
                  {t.sellerLabel}: {dress.seller}
                </a>
                <p className="text-lg font-bold text-pink-600">{dress.price.toLocaleString()} {lang === 'ar' ? 'ريال' : 'SAR'}</p>
                <Button className="w-full"><ShoppingCart className="mr-2" /> {t.contact}</Button>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
