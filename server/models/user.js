import _sequelize from "sequelize";
const { Model, Sequelize } = _sequelize;

export default class user extends Model {
  static init(sequelize, DataTypes) {
    return super.init({
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true
      },
      first_name: {
        type: DataTypes.STRING(100),
        allowNull: true
      },
      last_name: {
        type: DataTypes.STRING(100),        
        allowNull: true
      },
      email: {
        type: DataTypes.STRING(100),
        allowNull: true
      },
      countryCode: {
        type: DataTypes.STRING(20),
        allowNull: true
      },
      phone: {
        type: DataTypes.INTEGER,
        allowNull: true
      },
      password: {
        type: DataTypes.STRING(100),
        allowNull: true
      },
      fav_hotels: {
        type: DataTypes.JSON,
        allowNull: true
      },
      fav_locations: {
        type: DataTypes.JSON,
        allowNull: true
      },      
      isDeactivated: {
        type: DataTypes.BOOLEAN,
        allowNull: true,
      }
    }, {
      sequelize,
      tableName: 'user',
      timestamps: false,
      indexes: [
        {
          name: "PRIMARY",
          unique: true,
          using: "BTREE",
          fields: [
            { name: "id" },
          ]
        }
      ]
    });
  }
} 
