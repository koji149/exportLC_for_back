require "google_drive"

module Api
    module V1
      class PostsController < ApplicationController
        before_action :set_post, only: [:show, :update, :destroy]

        def export
          session = GoogleDrive::Session.from_config('google-credentials.json')
            root_folder_id = ENV['ROOT_FOLDER_ID']
            root_folder = session.collection_by_id(root_folder_id)

            sub_folder_id = ENV['SUB_FOLDER_ID']
            sub_folder = session.collection_by_id(sub_folder_id)

            template_sheets_id = ENV['TEMPLATE_SHEETS_ID']
            template_sheets = session.spreadsheet_by_key(template_sheets_id)

            sheet_your_idea = copy_sheets('あなたのアイデア', template_sheets, root_folder, sub_folder)
            update_sheets(sheet_your_idea)
        end

        private
        # テンプレートデータシートから任意のシート名、任意フォルダにシートをコピー
        def copy_sheets(sheets_name, template_sheets, root_folder, sub_folder)
          sheets = template_sheets.copy(sheets_name)
          sub_folder.add(sheets)
          # テンプレートファイルと同じフォルダにも新シートの参照が残るので削除しておく
          root_folder.remove(sheets)
          sheets
        end

        # シートのデータを更新
        def update_sheets(sheets)
          work_sheet = sheets.worksheets[1]
          work_sheet_key = sheets.key
          work_sheet[5,3] = params[:problem] # ①課題
          work_sheet[15,3] = params[:alternatives] # ②代替品
          work_sheet[5,6] = params[:solution] # ⑥ソリューション
          work_sheet[15,6] = params[:keyMetrics] # ⑩主要指標
          work_sheet[5,9] = params[:uniqueValue] # ⑤独自の価値提案
          work_sheet[5,13] = params[:unfairAdvantage] # ⑪圧倒的な優位性
          work_sheet[15,13] = params[:channels] # ⑦チャネル
          work_sheet[5,16] = params[:customer] # ③顧客セグメント
          work_sheet[15,16] = params[:earlyAdopters] # ④アーリーアダプター
          work_sheet[25,3] = params[:cost] # ⑨コスト構造
          work_sheet[25,11] = params[:revenue] # ⑧収益の流れ
          work_sheet.save
          render json: work_sheet_key

        end
      end
    end
  end