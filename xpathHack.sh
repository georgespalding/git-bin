
cat theVBfile \
#Trim namespace
| perl -pe 's#xmlns(\:\w+)?="\S*"##g' \
# apply xpath VBRetailMessage
| xmllint --format --xpath "/VBRetailMessage/Content/StockBalance/StockItems/StockItem/Id" - \
#make into lines extract numeric id from content adding linebreak
| perl -pe 's#<[^>]+>([^<]+)</[^>]+>#$1\n#g'


# apply xpath KLS MedicineData \
# make into statement suitable for SQL in clause ignoring any attributes \
cat theMedicineDataFile \
| xmllint --format --xpath "/MedicineData/GenericProducts/GenericProduct/TradeProducts/TradeProduct/ConsumerArticles/ConsumerArticle/Codes/Code[@domain='npl-pack.mpa.se']" - \
| perl -pe 's#<[^>]+>([^<]++)</[^>]+>#''$1'',#g'

# I cygwin måste man escape:a saker såhär: 
| perl -pe 's#<[^>]+>([^<]++)</[^>]+>#'"'"'$1'"'"',#g'


# Cygwin stylee ta fram antal fel per fil
for ix in `\ls -1rt CATRANRECEIPT_9497_*.xml` ;do echo -n "$ix #fel:";perl -pe 's#xmlns(\:\w+)?="\S*"##g' $ix|xmllint --xpath '/VBRetailMessage/Content/Order/ErrorInfo/ErrorCode' - |perl -pe 's#<[^>]+>([^<]+)</[^>]+>#$1\n#g'|wc -l;done



#plocka ut DeliveryTime från DispenseOrders
find . -newer limit -name 'pharmaconnect.DISPENSEORDER-*.xml' |xargs grep -l '<Dispense'|xargs -n 1 xmllint --xpath '/DispenseOrder/DeliveryTime' --format |perl -pe 's#<[^>]+>([^<]+)</[^>]+>#$1\n#g'



#Hacka fram PayEx fils underlag
touch -t 201305270700 start
find . -newer start -name 'server.log*'|xargs \ls -1art|xargs egrep -A 2 '<(Cash)?TransactionOrder'|cut -c 34- > TransactionOrder_20130527.txt 
##lägg in en tomrad överst
vi TransactionOrder_20130527.txt 
export LC_ALL=C
perl -pe '$/="\n\n";s#\s+##g;$_="$_\n"' TransactionOrder_20130527.txt | sort -u > TransactionOrder_20130527_oneline_sorted.txt
 
find . -newer start -name '*.dat'
find . -newer start -name 'CATRANR*'
